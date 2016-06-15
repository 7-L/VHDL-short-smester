library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity exp11 is
  port( 
       clk:in std_logic;                      		
       SM:out std_logic_vector(6 downto 0);   	
       SEL:buffer std_logic_vector(2 downto 0)    	
       );      
end entity; 
architecture SZ of exp11 is
begin	
	process(clk)
	begin 
		if(clk'event and clk ='1') then
			if(SEL=7)then
				SEL<="000";
			else SEL<=SEL+1;
			end if;
		end if;
    end process;
 process(SEL)
      begin
      case SEL  is
          when "000" => SM <="0000110";	
          when "001" => SM <="1001111";	           
          when "010" => SM <="0000110";	                 
          when "011" => SM <="0111111";	                 
          when "100" => SM <="0111111";	
          when "101" => SM <="0000110";	              
          when "110" => SM <="0000110";	
          when "111" => SM <="0111111";	
       end  case;
   end  process; 				
end architecture;