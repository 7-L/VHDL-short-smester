library ieee;
use ieee.std_logic_1164.all;

entity SVSftReg is
 port(clk:in std_logic;--N2, 输入时钟端
      set:in std_logic;--K3, 置位端，高电平有效
      flag:in std_logic;--K2, 标志端，高电平时移位寄存器实现左移功能，低电平时实现右移功能
      input:in std_logic;--K1, 串入数据
      output:out std_logic_vector(6 downto 0));--LED1-LED7, 并出数据
 end SVSftReg;

architecture behave of SVSftReg is
signal temp:std_logic_vector(6 downto 0);
   begin
   process(clk,set,flag,input)
   begin
		if set='1' then
			temp<="1111111";
		else
			if(clk'event and clk='1') then 
				if flag='1' then
					temp(0)<=input;
					temp(6 downto 1)<=temp(5 downto 0);
				else 
					temp(6)<=input;
					for i in 1 to 6 loop
						temp(i-1)<=temp(i);
					end loop;
				end if;
			end if;
		end if;
		output<=temp;
	end process;
end behave;
