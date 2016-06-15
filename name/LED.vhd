                              --  Title: 矩阵键盘显示            --
                            
--下面是引用库                             -------------------------------------
library ieee;        --库函数
use ieee.std_logic_1164.all;--定义了std_logic数据类型及相应运算
use ieee.std_logic_arith.all;--定义了signed和unsigned数据类型、相应运算和相关类型转换函数
use ieee.std_logic_unsigned.all;--定义了一些函数，可以使std_logic_vector类
                                 --型被当作符号数或无符号数一样进行运算
--------------------------------------------------------------------
--下面是构造实体
--------------------------------------------------------------------
entity LED is--exp10为实体名
  port( Clk              :  in      std_logic;   --时钟信号
        Kr               :  in      std_logic_vector(3 downto 0);   --键盘行
        Kc               :  buffer  std_logic_vector(3 downto 0);   --键盘列
        a,b,c,d,e,f,g    :  out     std_logic;   --七段码管显示
        Sa,sb,sc         :  buffer  std_logic);  --七段码管片选
end LED;--结束实体
--------------------------------------------------------------------
architecture behave of LED is  --behave为结构体名

  signal keyr,keyc     : std_logic_vector(3 downto 0);--键盘行 列 扫描 信号量
  signal kcount        : std_logic_vector(2 downto 0);
  signal dcount        : std_logic_vector(2 downto 0);
  signal kflag1,kflag2 : std_logic;
  signal buff1,buff2,buff3,buff4,buff5,buff6,buff7,buff8 : integer range 0 to 15;
  signal Disp_Temp     : integer range 0 to 15;
  signal Disp_Decode   : std_logic_vector(6 downto 0);
  
  begin
   
    process(Clk)  --扫描键盘 扫描键盘的列
      begin
        if(Clk'event and Clk='1') then    
          if(Kr="1111") then
              kflag1<='0';
              kcount<=kcount+1;
              if(kcount=0) then
                  kc<="1110";--扫描第一列
              elsif(kcount=1) then
                  kc<="1101";--扫描第二列
              elsif(kcount=2) then
                  kc<="1011";--扫描第三列
              else
                  kc<="0111"; --扫描第四列
              end if;
          else
              kflag1<='1';
              keyr<=Kr;
              keyc<=Kc;
          end if;
          kflag2<=kflag1;
        end if;  
      end process; 
    
    process(Clk)  --显示右移
      begin
        
        if(Clk'event and Clk='1') then--上升沿
           if(kflag1='1' and kflag2='0' ) then
              buff1<=buff2;--移位
              buff2<=buff3;
              buff3<=buff4;
              buff4<=buff5;
              buff5<=buff6;
              buff6<=buff7;
              buff7<=buff8;
           end if;
        end if;
    end process;                    
    process(Clk)  -- 获取键值
       begin
         if(Clk'event and Clk='1') then
           if(kflag1='1' and kflag2='0') then
              if(keyr="0111") then--扫描第一列
                 case keyc is
                    when "0111"=>buff8<=1;  --扫描第一行
                    when "1011"=>buff8<=4; --扫描第二行
                    when "1101"=>buff8<=7; --扫描第三行
                    when "1110"=>buff8<=14; --扫描第四行
                    when others=>buff8<=buff8;       --no change
                 end case;
              elsif(keyr="1011") then  --扫描第二列
                 case keyc is
                    when "0111"=>buff8<=2;  --扫描第一行
                    when "1011"=>buff8<=5;  --扫描第二行
                    when "1101"=>buff8<=8;  --扫描第三行
                    when "1110"=>buff8<=0;  --扫描第四行
                    when others=>buff8<=buff8;       --no change
                 end case;
              elsif(keyr="1101") then--扫描第三列
                 case keyc is
                    when "1110"=>buff8<=15;  --扫描第一行
                    when "1101"=>buff8<=9;  --扫描第二行
                    when "1011"=>buff8<=6; --扫描第三行
                    when "0111"=>buff8<=3;--扫描第四行
                    when others=>buff8<=buff8;       --no change
                 end case;
              elsif(keyr="1110") then  --扫描第四列
                 case keyc is
                    when "1110"=>buff8<=13;  --扫描第一行
                    when "1101"=>buff8<=12;  --扫描第二行
                    when "1011"=>buff8<=11; --扫描第三行
                    when "0111"=>buff8<=10;--扫描第四行
                    when others=>buff8<=buff8;       --no change
                 end case;
              end if;
           end if;                
         end if; 
    end process;
    process(dcount)      --数码管驱动扫描
      begin
        case (dcount) is
          when "000"=>Disp_Temp<=buff1;     --扫描第一个数码管
          when "001"=>Disp_Temp<=buff2;    --扫描第二个数码管 
          when "010"=>Disp_Temp<=buff3;  --扫描第三个数码管
          when "011"=>Disp_Temp<=buff4;
          when "100"=>Disp_Temp<=buff5;
          when "101"=>Disp_Temp<=buff6;
          when "110"=>Disp_Temp<=buff7;
          when "111"=>Disp_Temp<=buff8;    --'1'
       end case;   
    end process;

    process(Clk)
      begin
        if(Clk'event and Clk='1') then    --扫描累加 
           dcount<=dcount+1;
           a<=Disp_Decode(0);--七段数码管a段赋值
           b<=Disp_Decode(1);--七段数码管b段赋值
           c<=Disp_Decode(2);--七段数码管c段赋值
           d<=Disp_Decode(3);--七段数码管d段赋值
           e<=Disp_Decode(4);--七段数码管e段赋值
           f<=Disp_Decode(5);--七段数码管f段赋值
           g<=Disp_Decode(6);--七段数码管g段赋值
           sa<=dcount(0);--数码管的片选信号赋值第一位
           sb<=dcount(1);--数码管的片选信号赋值第二位
           sc<=dcount(2);--数码管的片选信号赋值第三位

        end if;
    end process;
    process(Disp_Temp)      --显示转换
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
          when others=>Disp_Decode<="0000000";   --全灭
        end case;
    end process;   

  end behave;

