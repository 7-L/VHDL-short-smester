LIBRARY IEEE;

USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY FbinaryComparison IS                      --四位比较器

    PORT(IA_MORE_THAN_B:IN STD_LOGIC;     --高位比较的标志位的输入

        IB_MORE_THAN_A:IN STD_LOGIC;

        IA_EQUAL_B:IN STD_LOGIC;

        A:IN STD_LOGIC_VECTOR(3 DOWNTO 0);--两个输入

        B:IN STD_LOGIC_VECTOR(3 DOWNTO 0);

        OA_MORE_THAN_B:OUT STD_LOGIC;

        OB_MORE_THAN_A:OUT STD_LOGIC;

        OA_EQUAL_B:OUT STD_LOGIC);

    END FbinaryComparison;

ARCHITECTURE BEHAV OF FbinaryComparison IS

BEGIN

    PROCESS(IB_MORE_THAN_A, IA_EQUAL_B,IA_EQUAL_B)

    BEGIN

        IF(IA_EQUAL_B='1')THEN
--从最高位比较，如果高位大则停止比较输出结果，否则进行下一位比较

        IF(A(3)>B(3))THEN                 

            OA_MORE_THAN_B<='1';OB_MORE_THAN_A<='0';OA_EQUAL_B<='0';

        ELSIF(A(3)<B(3))THEN

            OA_MORE_THAN_B<='0';OB_MORE_THAN_A<='1';OA_EQUAL_B<='0';

        ELSIF(A(2)>B(2))THEN

            OA_MORE_THAN_B<='1';OB_MORE_THAN_A<='0';OA_EQUAL_B<='0';

        ELSIF(A(2)<B(2))THEN

            OA_MORE_THAN_B<='0';OB_MORE_THAN_A<='1';OA_EQUAL_B<='0';

        ELSIF(A(1)>B(1))THEN

            OA_MORE_THAN_B<='1';OB_MORE_THAN_A<='0';OA_EQUAL_B<='0';

        ELSIF(A(1)<B(1))THEN

            OA_MORE_THAN_B<='0';OB_MORE_THAN_A<='1';OA_EQUAL_B<='0';

        ELSIF(A(0)>B(0))THEN

            OA_MORE_THAN_B<='1';OB_MORE_THAN_A<='0';OA_EQUAL_B<='0';

        ELSIF(A(0)<B(0))THEN

            OA_MORE_THAN_B<='0';OB_MORE_THAN_A<='1';OA_EQUAL_B<='0';

        ELSE   

--如果输入中两个数相等的标志位为0，则表明高位不相等，停止比较，输出结果。

            OA_MORE_THAN_B<='0';OB_MORE_THAN_A<='0';OA_EQUAL_B<='1';

        END IF;

    ELSE

OA_MORE_THAN_B<=IA_MORE_THAN_B;OB_MORE_THAN_A<=IB_MORE_THAN_A;

OA_EQUAL_B<=IA_EQUAL_B;

    END IF;

    END PROCESS;

END BEHAV;