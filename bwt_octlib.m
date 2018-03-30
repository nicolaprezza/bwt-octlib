#main function
function []=bwt_octlib(s)
  

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

#compute the symmetric BWT of s
function sb = SBWT(s)

  si = flip(s); #reverse of s
  sa = SA(s); #SA of s
  sai = SA(si);#SA of si
  bwt = BWT(s);#BWT of s
  
  n = length(s);
  
  #scan SA
  for j = 1:n
    
    #scan ISA
    for i = 1:n
    
      if sai(i) == (mod(2-sa(j),n)+1) 
    
        sb(j,i) = bwt(j);
    
      else
    
        sb(j,i) = ' ';
    
      endif
    
    end    
  
  end
  
end


#compute chi permutation
function chi = CHI(s)

  si = flip(s); #reverse of s
  sa = SA(s); #SA of s
  sai = SA(si);#SA of si
  bwt = BWT(s);#BWT of s
  
  n = length(s);
  
  #scan SA
  for j = 1:n
    
    #scan SA of reverse
    for i = 1:n
    
      if sai(i) == (mod(2-sa(j),n)+1) 
    
        chi(j) = i;
    
      endif
    
    end    
  
  end
  
end


