#include "hardware.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define WDTCTL_               0x0120    /* Watchdog Timer Control */
//#define WDTHOLD             (0x0080)
//#define WDTPW               (0x5A00)

#define METADATA_START 0x160
#define METADATA_END  (METADATA_START + 8) // 4 bytes per region and assuming 2 regions
uint16_t ucc1min __attribute__((section (".ucc1min"))) = 0xE1EE;
uint16_t ucc1max __attribute__((section (".ucc1max"))) = 0xE250;
uint16_t ucc2min __attribute__((section (".ucc2min"))) = 0xE252;
uint16_t ucc2max __attribute__((section (".ucc2max"))) = 0xE2C0;

/**
 * main.c
 */

char* test_password = "chaos";
int counter = 0;


/* A function to stand in for some secure operation
   In this psuedo-program it simply increments a counter but this 
   is a stand in for what would be what runs after the user logs in
*/
void secureFunction(void){
    counter++;
}


// REGION ONE //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

__attribute__ ((section (".regionOne.exit"), naked)) void regionOneExit(){
    __asm__ volatile("ret" "\n\t");
}


/* simplistic way of copy strings from one buffer to another */
__attribute__ ((section (".regionOne.body"))) void stringCopy(char *dst, char *src){
    int n = strlen(src);
    for(int i=0; i<n; i++){
        dst[i] = src[i];
    }
    
}

/* Stand in for getting user input. Instead we copy the "input" from one buffer we set to a new buffer
   buffer is defined within this function to allow for an overflow to occur  however buffer is simply copied into
   the output pointer for later use
*/
__attribute__ ((section (".regionOne.body"))) void getUserInput(char* output, char *input){
    char buffer[6] = {'\0'};
   
    stringCopy(buffer, input);
    stringCopy(output, buffer);
}


__attribute__ ((section (".regionOne.entry"), naked)) void regionOne(char* buffer, char *userInput, char *password){
    getUserInput(buffer, userInput);
     __asm__ volatile( "br #__region_one_leave" "\n\t");
}

// REGION TWO ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

__attribute__ ((section (".regionTwo.exit"), naked)) void regionTwoExit(){
    __asm__ volatile("ret" "\n\t");
}

/* A simple string comparison function. In reality since this operation effects the secure execution 
of the device it wouldnt be in an untrusted region however we made it a second region for testing purposes
*/
__attribute__ ((section (".regionTwo.body"))) int passwordComparison(char *actual, char *attempt){
    int n = strlen(actual);
    int m = strlen(attempt);
    
    if (n!=m){
        return -1;
    }else{
        for(int i=0; i<n; i++){
            if (actual[i] != attempt[i]){
                return -1;
            }
        }
        return 0;
    }
}



__attribute__ ((section (".regionTwo.entry"), naked)) void regionTwo(int *result, char *attempt, char *password){
    *result = passwordComparison(password, attempt);
     __asm__ volatile( "br #__region_two_leave" "\n\t");
}

// MAIN /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int main(void)
{

        uint32_t* wdt = (uint32_t*)(WDTCTL_);
        *wdt = WDTPW | WDTHOLD;

        
        //Writes to the middle of CR
	*((uint16_t*)(METADATA_START + 4)) = 0xE456;



	 // serves as the user input
	 char input[6] = {'c', 'h', 'a', 'o', 's', '\0'};

         while (1){

            char *buffer = malloc(6);
            memset(buffer, 0, 6);
            
            int *result = malloc(sizeof(int));
            *result = -1;
            
	    regionOne(buffer, input, test_password); 
	    
	    regionTwo(result, buffer, test_password);
	    
	    if (*result == 0){
	        secureFunction();
	    }
	    free(buffer);
	    free(result);
	}
        return 0;
}
