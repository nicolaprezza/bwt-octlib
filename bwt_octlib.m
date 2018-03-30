#main function
function []=bwt_octlib(s)

  s;
  BWT(s)
  rotations(s);
  sort(rotations(s));
  SA(s);
  ISA(s);

end


#input: string s
#output: square matrix of rotations of s
function M = rotations(s)

	M = {s};
	len=length(s);

	for i = 1:(len-1)

		newrow = "";
    
		for j = 2:len
	
			newrow = strcat( newrow,char(M(end))(j) );

		end

    newrow = strcat( newrow,char(M(end))(1) );
    
		M(end+1) = newrow;

	end

end


#input: string s
#output: BWT(s)
function bwt = BWT(s)

	M = {s};
	len=length(s);

	for i = 1:(len-1)

		newrow = "";
    
		for j = 2:len
	
			newrow = strcat( newrow,char(M(end))(j) );

		end

    newrow = strcat( newrow,char(M(end))(1) );
    
		M(end+1) = newrow;

	end
  
  M = sort(M);
  
  bwt = "";
  
  for i = 1:len

    bwt = strcat( bwt,char(M(i))(end) );

  end


end


#return suffix array of s
function sa = SA(s)

  M = rotations(s);
	Msort = sort(M);
  len=length(s);

	sa = []; #init empty suffix array

	for i = 1:len

		for j = 1:len

      if strcmp(Msort(i),M(j))
      
        sa(i) = j;
      
      end
	
		end
	
	end

end


#return inverse suffix array of s
function isa = ISA(s)

  M = rotations(s);
	Msort = sort(M);
  len=length(s);

	isa = []; #init empty suffix array

	for i = 1:len

		for j = 1:len

      if strcmp(Msort(i),M(j))
      
        isa(j) = i;
      
      end
	
		end
	
	end

end



