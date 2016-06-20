library ieee;
use ieee.std_logic_1164.all;
entity exp3 is
	port (
		clk,reset,contral:in std_logic;     --clkʱ��reset����contral���ƼӼ���
		cout:out std_logic_vector(1 downto 0)); --�����
end exp3;
architecture behave of exp3 is
	signal cp:std_logic;
	signal cn:std_logic_vector(1 downto 0);  --��ʾ��������
	signal cn0,cn1,scn1,scn0:std_logic;    --cn0 ,cn1��ʾ�ӷ��ĵ͸�λ��scn0,scn1 ��ʾ�����ĵ͸�λ
	begin 
		process(clk,contral,cn,cn0,scn0,cn1,scn1)
			begin 
			cp<= not clk;
				if contral='1' then       --�ӷ�����
					cn<=cn1&cn0;
				else				     --��������
					cn<=scn1&scn0;
				end if;
				if clk' event and clk='1'then
					cn0<=not cn0;      --�ӷ���λȡ��
					scn0<=not scn0;    --������λȡ��
				end if;
				if cn0' event and cn0='0'then
					cn1<=not cn1;      --�ӷ���λȡ��
				end if;
				if scn0'event and scn0='1'then
					scn1<=not scn1;    --������λȡ��
				end if;
				if reset='1'then         --����
					cout<="00";
				ELSE
					cout<=CN;
				END IF;
		end process;
end behave;
