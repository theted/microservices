One_hailstone_step_in_Whitespace._Only_spaces,_tabs_and_newlines_count,_so_every_visible_word_here_is_a_comment_and_the_program_is_the_blank_bits._push0    
readnum	
		push0    
retrieve			dup 
 push2   	 
mod	 		jz_even
	 	
push3   		
mul	  
push1   	
add	   printnum	
 	push10   	 	 
printchar	
  end


even:
  	
push2   	 
div	 	 printnum	
 	push10   	 	 
printchar	
  end


