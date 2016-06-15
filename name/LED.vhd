                              --  Title: ���������ʾ            --
                            
--���������ÿ�                             -------------------------------------
library ieee;        --�⺯��
use ieee.std_logic_1164.all;--������std_logic�������ͼ���Ӧ����
use ieee.std_logic_arith.all;--������signed��unsigned�������͡���Ӧ������������ת������
use ieee.std_logic_unsigned.all;--������һЩ����������ʹstd_logic_vector��
                                 --�ͱ��������������޷�����һ����������
--------------------------------------------------------------------
--�����ǹ���ʵ��
--------------------------------------------------------------------
entity LED is--exp10Ϊʵ����
  port( Clk              :  in      std_logic;   --ʱ���ź�
        Kr               :  in      std_logic_vector(3 downto 0);   --������
        Kc               :  buffer  std_logic_vector(3 downto 0);   --������
        a,b,c,d,e,f,g    :  out     std_logic;   --�߶������ʾ
        Sa,sb,sc         :  buffer  std_logic);  --�߶����Ƭѡ
end LED;--����ʵ��
--------------------------------------------------------------------
architecture behave of LED is  --behaveΪ�ṹ����

  signal keyr,keyc     : std_logic_vector(3 downto 0);--������ �� ɨ�� �ź���
  signal kcount        : std_logic_vector(2 downto 0);
  signal dcount        : std_logic_vector(2 downto 0);
  signal kflag1,kflag2 : std_logic;
  signal buff1,buff2,buff3,buff4,buff5,buff6,buff7,buff8 : integer range 0 to 15;
  signal Disp_Temp     : integer range 0 to 15;
  signal Disp_Decode   : std_logic_vector(6 downto 0);
  
  begin
   
    process(Clk)  --ɨ����� ɨ����̵���
      begin
        if(Clk'event and Clk='1') then    
          if(Kr="1111") then
              kflag1<='0';
              kcount<=kcount+1;
              if(kcount=0) then
                  kc<="1110";--ɨ���һ��
              elsif(kcount=1) then
                  kc<="1101";--ɨ��ڶ���
              elsif(kcount=2) then
                  kc<="1011";--ɨ�������
              else
                  kc<="0111"; --ɨ�������
              end if;
          else
              kflag1<='1';
              keyr<=Kr;
              keyc<=Kc;
          end if;
          kflag2<=kflag1;
        end if;  
      end process; 
    
    process(Clk)  --��ʾ����
      begin
        
        if(Clk'event and Clk='1') then--������
           if(kflag1='1' and kflag2='0' ) then
              buff1<=buff2;--��λ
              buff2<=buff3;
              buff3<=buff4;
              buff4<=buff5;
              buff5<=buff6;
              buff6<=buff7;
              buff7<=buff8;
           end if;
        end if;
    end process;                    
    process(Clk)  -- ��ȡ��ֵ
       begin
         if(Clk'event and Clk='1') then
           if(kflag1='1' and kflag2='0') then
              if(keyr="0111") then--ɨ���һ��
                 case keyc is
                    when "0111"=>buff8<=1;  --ɨ���һ��
                    when "1011"=>buff8<=4; --ɨ��ڶ���
                    when "1101"=>buff8<=7; --ɨ�������
                    when "1110"=>buff8<=14; --ɨ�������
                    when others=>buff8<=buff8;       --no change
                 end case;
              elsif(keyr="1011") then  --ɨ��ڶ���
                 case keyc is
                    when "0111"=>buff8<=2;  --ɨ���һ��
                    when "1011"=>buff8<=5;  --ɨ��ڶ���
                    when "1101"=>buff8<=8;  --ɨ�������
                    when "1110"=>buff8<=0;  --ɨ�������
                    when others=>buff8<=buff8;       --no change
                 end case;
              elsif(keyr="1101") then--ɨ�������
                 case keyc is
                    when "1110"=>buff8<=15;  --ɨ���һ��
                    when "1101"=>buff8<=9;  --ɨ��ڶ���
                    when "1011"=>buff8<=6; --ɨ�������
                    when "0111"=>buff8<=3;--ɨ�������
                    when others=>buff8<=buff8;       --no change
                 end case;
              elsif(keyr="1110") then  --ɨ�������
                 case keyc is
                    when "1110"=>buff8<=13;  --ɨ���һ��
                    when "1101"=>buff8<=12;  --ɨ��ڶ���
                    when "1011"=>buff8<=11; --ɨ�������
                    when "0111"=>buff8<=10;--ɨ�������
                    when others=>buff8<=buff8;       --no change
                 end case;
              end if;
           end if;                
         end if; 
    end process;
    process(dcount)      --���������ɨ��
      begin
        case (dcount) is
          when "000"=>Disp_Temp<=buff1;     --ɨ���һ�������
          when "001"=>Disp_Temp<=buff2;    --ɨ��ڶ�������� 
          when "010"=>Disp_Temp<=buff3;  --ɨ������������
          when "011"=>Disp_Temp<=buff4;
          when "100"=>Disp_Temp<=buff5;
          when "101"=>Disp_Temp<=buff6;
          when "110"=>Disp_Temp<=buff7;
          when "111"=>Disp_Temp<=buff8;    --'1'
       end case;   
    end process;

    process(Clk)
      begin
        if(Clk'event and Clk='1') then    --ɨ���ۼ� 
           dcount<=dcount+1;
           a<=Disp_Decode(0);--�߶������a�θ�ֵ
           b<=Disp_Decode(1);--�߶������b�θ�ֵ
           c<=Disp_Decode(2);--�߶������c�θ�ֵ
           d<=Disp_Decode(3);--�߶������d�θ�ֵ
           e<=Disp_Decode(4);--�߶������e�θ�ֵ
           f<=Disp_Decode(5);--�߶������f�θ�ֵ
           g<=Disp_Decode(6);--�߶������g�θ�ֵ
           sa<=dcount(0);--����ܵ�Ƭѡ�źŸ�ֵ��һλ
           sb<=dcount(1);--����ܵ�Ƭѡ�źŸ�ֵ�ڶ�λ
           sc<=dcount(2);--����ܵ�Ƭѡ�źŸ�ֵ����λ

        end if;
    end process;
    process(Disp_Temp)      --��ʾת��
      begin
        case Disp_Temp is
          when 0=>Disp_Decode<="0111111";   --'0'
          when 1=>Disp_Decode<="0000110";   --'1'
          when 2=>Disp_Decode<="1011011";   --'2'
          when 3=>Disp_Decode<="1001111";   --'3'
          when 4=>Disp_Decode<="1100110";   --'4'
          when 5=>Disp_Decode<="1101101";   --'5'
          when 6=>Disp_Decode<="1111101";   --'6'
          when 7=>Disp_Decode<="0000111";   --'7'
          when 8=>Disp_Decode<="1111111";   --'8'
          when 9=>Disp_Decode<="1101111";   --'9'
          when 10=>Disp_Decode<="1110111";  --'A'
          when 11=>Disp_Decode<="1111100";  --'b'
          when 12=>Disp_Decode<="0111001";  --'C'
          when 13=>Disp_Decode<="1011110";  --'d'
          when 14=>Disp_Decode<="1111001";  --'E'
          when 15=>Disp_Decode<="1110001";  --'-'
          when others=>Disp_Decode<="0000000";   --ȫ��
        end case;
    end process;   

  end behave;

