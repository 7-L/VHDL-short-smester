library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity taxi_counter is 
	port(Clk:   	in std_logic;
		 Rst:       in std_logic;
		 Motor:     in std_logic;
		 Display:   out std_logic_vector(6 downto 0);
		 Dp:        buffer std_logic;
		 DATA_SET:   buffer std_logic_vector(2 downto 0));
end taxi_counter;

architecture behave of taxi_counter is
	signal TEMP:integer range 0 to 15;
	signal Disp:std_logic_vector(6 downto 0);
	signal Meter1,Meter10,Meter100,Meter1K:integer range 0 to 9;
	signal Money0,Money1,Money10:integer range 0 to 9;
	signal Old_Money1:integer range 0 to 9;

begin 

process(Clk)
begin 
	if(Rst='0')then
	   Money0<=0;
	   Money1<=0;
	   Money10<=1;
	elsif(Clk'event and Clk='1')then
	   if (Meter1K<1)then 
		 Money10<=1;
		 Money1<=3;
		 Money0<=0;
		 Old_Money1<=0;
 	   else
 	   	 Money0<=Meter100;
 	   	 Old_Money1<=Money0;
 	   	 if(Old_Money1=9 and Money0=0)then
 	   	 	if(Money1=9)then
 	   	 		Money1<=0;
 	   	 			if(Money10=9)then
 	   	 				Money10<=0;
 	   	 		 	else
 	   	 		 	 	Money10<=Money10+1;
 	   	 		 	 end if;
 	   	 		 	else
 	   	 		 		Money1<=Money1+1;
 	   	 		 	end if;
 	     	 end if;
   	 	end if;
 	 end if;
end process;

process(Motor)
	begin 
	if(rst='0')then
		Meter1<=0;
		Meter10<=0;
		Meter100<=0;
		Meter1K<=0;
	elsif(Motor'event and Motor='1')then
		if(Meter1=9)then
			Meter1<=0;
		     if(Meter10=9)then
			   Meter10<=0;
			    if(Meter100=9)then
			      Meter100<=0;
			       if(Meter1K=9)then
			 		 Meter1K<=0;
			 	   else
			 	     Meter1K<=Meter1K+1;
			 	     end if;
			 	else
			 	  Meter100<=Meter100+1;
			 	end if;
			else 
			  Meter10<=Meter10+1;
			end if;
		else
		  Meter1<=Meter1+1;
		end if;
	end if;
end process;



process(DATA_SET)
begin
	case(DATA_SET+1)is
		when"000"=>TEMP<=Meter1K;
		when"001"=>TEMP<=Meter100;
		when"010"=>TEMP<=Meter10;
		when"011"=>TEMP<=Meter1;
		when"100"=>TEMP<=10;
		when"101"=>TEMP<=Money10;
		when"110"=>TEMP<=Money1;
		when"111"=>TEMP<=Money0;
	end case;
end process;

process(Clk)
begin
	if(Clk'event and Clk='1')then
		DATA_SET<=DATA_SET+1;
		if(DATA_SET=5)then
		 Display<=Disp or "0000000";
		else
		 Display<=Disp;
		end if;
	end if;
end process;

process(TEMP)
begin
	if(DATA_SET="110") Then
		Dp<='1';
	  else
		Dp<='0';
	 end if;  
	case TEMP is 
	  when 0=>Disp<="0111111";
	  when 1=>Disp<="0000110";
	  when 2=>Disp<="1011011";
	  when 3=>Disp<="1001111";
	  when 4=>Disp<="1100110";
	  when 5=>Disp<="1101101";
	  when 6=>Disp<="1111101";
	  when 7=>Disp<="0000111";
	  when 8=>Disp<="1111111";
	  when 9=>Disp<="1101111";
	  when 10=>Disp<="1000000";
	  when others=>Disp<="0000000";
	end case;
end process;
end behave;

