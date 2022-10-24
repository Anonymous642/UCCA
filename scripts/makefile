default :

install-clean :
	rm -rf ./verif-tools/verilog2smv-1.1.2 ./verif-tools/verilog2smv.sh	

install :
	cd verif-tools ; \
	tar -vxjf verilog2smv-1.1.2.tar.bz2 ; \
	cd verilog2smv-1.1.2 ; \
	sh build.sh ; \
	cp verilog2smv.sh ../

simple_app :
	sh build/run "simple_app" true

invalid_region_lt :
	sh build/run "violations_region_validity/invalid_region_lt" true
	
invalid_region_eq :
	sh build/run "violations_region_validity/invalid_region_eq" true

cr_write_fst :
	sh build/run "violations_cr_integrity/cr_write_fst" true
		
cr_write_mid :
	sh build/run "violations_cr_integrity/cr_write_mid" true
	
cr_write_last :
	sh build/run "violations_cr_integrity/cr_write_last" true
	
malicious_return_simple :
	sh build/run "violations_return_integrity/malicious_return_simple" true
	
malicious_return_complex :
	sh build/run "violations_return_integrity/malicious_return_complex" true
	
malicious_stack_write_simple :
	sh build/run "violations_stack_protection/malicious_stack_write_simple" true
	
malicious_stack_write_complex :
	sh build/run "violations_stack_protection/malicious_stack_write_complex" true
	
write_to_pointer :
	sh build/run "violations_stack_protection/write_to_pointer" true
	
malicious_jump_into_mid :
	sh build/run "violations_controlled_invocation/malicious_jump_into_mid" true
	
malicious_jump_into_last :
	sh build/run "violations_controlled_invocation/malicious_jump_into_last" true
	
malicious_jump_out_mid :
	sh build/run "violations_controlled_invocation/malicious_jump_out_mid" true
	
malicious_jump_out_fst :
	sh build/run "violations_controlled_invocation/malicious_jump_out_fst" true
	
malicious_jump_between_uccs :
	sh build/run "violations_controlled_invocation/malicious_jump_between_uccs" true
	
malicious_jump_within :
	sh build/run "violations_controlled_invocation/malicious_jump_within" true
verify :
	sh verif-tools/run

clean :
	rm -rf simv *.mem pmem.inc stimulus.v tmp-build
