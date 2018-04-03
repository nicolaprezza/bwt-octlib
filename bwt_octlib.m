#main function
function []=bwt_octlib(s)
 
 darkGrey  = [0.2 0.2 0.2];
 brown       = [0.2 0 0];
 orange      = [1 0.5 0];
 

 disp("Stringa:");
 disp(s); 
 len = length(s);
 disp(len) 
 
 fw = sort(rotations(s));
 
 rev = sort(rotations(flip(s)));
 
 bwt = BWT(s);
 
 % Define x and y
 ascisse = [1: len] ;
 chi = CHI(s);
 
 % Open a new figure
 figure;
 
 % Turn hold on so all the points can 
 % be plotted individually
 hold on;

 grid on;
 
 %set (gca, "ygrid", "on");
 
 % Calculation for the amount by which the
 % label should be displaced in the 'y'
 % direction
 lbl_dwn = .015*max(chi);
 % plot and label the individual points
 for i = 1:len
    if (bwt(i) =='A')
        plot(ascisse(i),chi(i),'o','MarkerEdgeColor','r');
        % Label the points with the corresponding 'x' value
        text(ascisse(i)+lbl_dwn,chi(i)+lbl_dwn, bwt(i), 'Color','red');
    elseif (bwt(i) == 'C')
        plot(ascisse(i),chi(i),'o','MarkerEdgeColor','b');
        % Label the points with the corresponding 'x' value
        text(ascisse(i)+lbl_dwn,chi(i)+lbl_dwn, bwt(i), 'Color','blue');
    elseif (bwt(i) == 'G')
        plot(ascisse(i),chi(i),'o','MarkerEdgeColor','g');
        % Label the points with the corresponding 'x' value
        text(ascisse(i)+lbl_dwn,chi(i)+lbl_dwn, bwt(i), 'Color','green');
    elseif (bwt(i) == 'T')
        plot(ascisse(i),chi(i),'o','MarkerEdgeColor', darkGrey);
        % Label the points with the corresponding 'x' value
        text(ascisse(i)+lbl_dwn,chi(i)+lbl_dwn, bwt(i),'Color', brown);
    else
        plot(ascisse(i),chi(i),'o','MarkerEdgeColor','k');
        % Label the points with the corresponding 'x' value
        text(ascisse(i)+lbl_dwn,chi(i)+lbl_dwn, bwt(i), 'Color','black');
    end
 end


 xlabel('Forward suffixes');
 ylabel('Reverse suffixes');
 titolo= strcat('FW (', s, ') vs REV (', flip(s),')');
 title(titolo);

 

 labelOrdinate = rev
 set(gca,'YTick',1:len)
 set(gca,'Yticklabel',labelOrdinate);


 %labelAscisse = fw
 %set(gca,'Xticklabel',labelAscisse);
 %set(gca,'XTickLabelRotation',45);

 xtick=[1:len];
 set(gca,'xtick',xtick);
 xticklabel=fw;
 set(gca,'xticklabel',xticklabel);

 ## get position of current xtick labels
 h = get(gca,'xlabel');
 xlabelstring = get(h,'string');
 xlabelposition = get(h,'position');

 ## construct position of new xtick labels
 yposition = xlabelposition(2);
 yposition = repmat(yposition,length(xtick),1);

 %%%%%%%
 %Disabiitando xtick non inserire le linee verticali della griglia 
 ## disable current xtick labels
 set(gca,'xtick',[]);

 ## set up new xtick labels and rotate
 hnew = text(xtick, yposition, xticklabel);
 set(hnew,'rotation',90,'horizontalalignment','right');
  %%%%%%%

 print plot.pdf
 
 hold off;

 
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


