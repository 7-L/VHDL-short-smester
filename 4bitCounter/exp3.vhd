library ieee;
use ieee.std_logic_1164.all;
entity exp3 is
	port (
		clk,reset,contral:in std_logic;     --clk时钟reset清零contral控制加减法
		cout:out std_logic_vector(1 downto 0)); --—输出
end exp3;
architecture behave of exp3 is
	signal cp:std_logic;
	signal cn:std_logic_vector(1 downto 0);  --表示二进制数
	signal cn0,cn1,scn1,scn0:std_logic;    --cn0 ,cn1表示加法的低高位，scn0,scn1 表示减法的低高位
	begin 
		process(clk,contral,cn,cn0,scn0,cn1,scn1)
			begin 
			cp<= not clk;
				if contral='1' then       --加法计数
					cn<=cn1&cn0;
				else				     --减法计数
					cn<=scn1&scn0;
				end if;
				if clk' event and clk='1'then
					cn0<=not cn0;      --加法低位取反
					scn0<=not scn0;    --减法低位取反
				end if;
				if cn0' event and cn0='0'then
					cn1<=not cn1;      --加法高位取反
				end if;
				if scn0'event and scn0='1'then
					scn1<=not scn1;    --减法高位取反
				end if;
				if reset='1'then         --清零
					cout<="00";
				ELSE
					cout<=CN;
				END IF;
		end process;
end behave;
