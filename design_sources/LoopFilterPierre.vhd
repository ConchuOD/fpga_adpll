library IEEE ;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.MATH_REAL.all;
use IEEE.NUMERIC_STD.all;

entity PI_Filter_v1 is
	port(	RST 		 : in  std_logic;
            Error 	     : in  std_logic_vector(4 downto 0);
            Ki_i         : in  std_logic_vector(3 downto 0);
            Kp_i         : in  std_logic_vector(3 downto 0);
            Ke           : in  std_logic_vector(19 downto 0);
			CLK_DCO 	 : in  std_logic;
            temp_8bit_bus1 : out std_logic_vector(7 downto 0);
            temp_8bit_bus2 : out std_logic_vector(7 downto 0);
			Sig_out 	 : out std_logic_vector(4 DOWNTO 0));
end PI_Filter_v1;

architecture Behavioral of PI_Filter_v1 is
signal Kp 	        : integer range 0 to 15; -- de 1 à 32, divided by 64 later
signal Ki   		: integer range 0 to 15; -- divided by 2048 later

signal Error_int    : integer range -2**4  to 2**4-1 ;
signal Error_int_buf: integer range -2**4  to 2**4-1 ;

signal x_prop 		: integer range -2**8 to 2**8-1;

signal x_int1   	: integer range -2**16 to 2**16-1;
signal x_int   	    : integer range -2**16 to 2**16-1;
signal x_int_fb	    : integer range -2**16 to 2**16-1;

signal Sig_out_tmp  : integer range -2**4  to 2**4-1;
--signal Sig_out_tmp1  : integer range -2**9 to 2**9-1;


signal e1, e2, e3, e4           : integer range -2**6 to 2**6-1; -- 7b
signal kw1, kw2, kw3, kw4       : integer range 0 to 7; -- 2b

begin

-- ********************************************************* --
--          BLOCS POUR SOMMER LES ERREURS                    --
--          ERROR COMBINER (UNUSED)                          --
-- ********************************************************* --
kw1  <= 4 when Ke(2 downto 0)   ="100" else
        3 when Ke(2 downto 0)   ="011" else
        2 when Ke(2 downto 0)   ="010" else
        1 when Ke(2 downto 0)   ="001" else
        0 when Ke(2 downto 0)   ="000" ;
        
kw2  <= 4 when Ke(5 downto 3)   ="100" else
        3 when Ke(2 downto 0)   ="011" else
        2 when Ke(5 downto 3)   ="010" else
        1 when Ke(5 downto 3)   ="001"else
        0 when Ke(5 downto 3)   ="000";
        
kw3  <= 4 when Ke(8 downto 6)   ="100" else
        3 when Ke(2 downto 0)   ="011" else
        2 when Ke(8 downto 6)   ="010" else
        1 when Ke(8 downto 6)   ="001"else
        0 when Ke(8 downto 6)   ="000";
        
kw4  <= 4 when Ke(11 downto 9)  ="100" else
        3 when Ke(2 downto 0)   ="011" else
        2 when Ke(11 downto 9)  ="010" else
        1 when Ke(11 downto 9)  ="001"else 
        0 when Ke(11 downto 9)  ="000";

-- e1  <= kw1 * to_integer(signed(Error1));
-- e2  <= kw2 * to_integer(signed(Error2));
-- e3  <= kw3 * to_integer(signed(Error3));
-- e4  <= kw4 * to_integer(signed(Error4));

-- Error_int_buf  <= (e1 + e2 + e3 + e4)/4;
Error_int_buf   <= to_integer(signed(Error));

-- ********************************************************* --
--                  REGISTRE D'ENTRE                         --
--                  INPUT BUFFER                             --
-- ********************************************************* --
process (CLK_DCO) begin
    if (CLK_DCO'event and CLK_DCO='1') then
        Error_int		<=  Error_int_buf;
    end if;
end process;


-- ********************************************************* --
--          CHEMIN PROPORTIONNEL ET INTEGRATEUR              --
--          PROPORTIONAL AND INTEGRAL PATH                   --
-- ********************************************************* --
Kp              <= to_integer(unsigned(Kp_i)); -- to_integer(unsigned(Ke(19 downto 16)));
Ki              <= to_integer(unsigned(Ki_i)); -- to_integer(unsigned(Ke(15 downto 12)));

x_prop 	        <= Kp * Error_int;   
--x_prop 	        <= Error_int;   

x_int1          <= Ki * Error_int;
x_int           <= x_int1 + x_int_fb;

-- (4*16) = 64  : /4 pour l'erreur, /(16) pour real Kp
-- 8*4*16 = 512 : /4 pour l'erreur, /(8*16)=128 pour real Ki

--Sig_out_tmp    <= (x_prop + x_int/8)/64 ;
--Sig_out_tmp    <= (x_prop + x_int/16)/64 ;

--Sig_out_tmp    <= (x_prop + x_int/16)/64 ;
Sig_out_tmp    <= (x_prop + x_int/16)/64 ;


  
-- delay pour boucle integrale
-- delay for integral path
process (RST, CLK_DCO) begin
	if (RST ='0') then
		x_int_fb <= 0;
	elsif (CLK_DCO'event and CLK_DCO='1') then
		x_int_fb <= x_int;
	end if;
end process;

-- ********************************************************* --
--                  REGISTRE DE SORTIE                       --
--                  OUTPUT BUFFER                            --
-- ********************************************************* --
process (RST, CLK_DCO) begin
    if (RST = '0') then
        Sig_out		<= "00000";
    elsif (CLK_DCO'event and CLK_DCO='1') then
        Sig_out		<=  std_logic_vector(to_signed(Sig_out_tmp, 5));
    end if;
end process;

end Behavioral;
