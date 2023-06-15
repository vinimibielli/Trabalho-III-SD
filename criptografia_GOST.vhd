--------------------------------------
-- TRABALHO TP3 - 13/JUNHO/2023
--------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all; 

--------------------------------------
-- Entidade
--------------------------------------

entity criptografia_GOST is 
	port(
		start, enc_dec, reset, clock	:	in	std_logic;
		data_i							:	in 	std_logic_vector(63 downto 0);
		key_i							: 	in	std_logic_vector(255 downto 0);
		busy_o, ready_o					:	out	std_logic;
		data_o							:	out	std_logic_vector(63 downto 0));
end entity;

--------------------------------------
-- Arquitetura
--------------------------------------

architecture Arquitetura of criptografia_GOST is
	signal i : std_logic_vector(4 downto 0);
	signal j : std_logic_vector(2 downto 0);
	signal enc_count : std_logic_vector(2 downto 0);
	signal dec_count : std_logic_vector(2 downto 0);
	signal key_count : std_logic_vector(2 downto 0);
	signal MSB : std_logic_vector(31 downto 0);
	signal LSB : std_logic_vector(31 downto 0);
	signal CM1 : std_logic_vector(31 downto 0);
	signal CM1aux : std_logic_vector(31 downto 0);
	signal shift11 : std_logic_vector(31 downto 0);
	signal atraso : std_logic := '0';
	signal Ni : std_logic_vector(7 downto 0);
	signal NiValor : std_logic_vector(3 downto 0);
	signal integerJ : integer := 0;
	signal NiInteger : integer := 0;
	signal mask : std_logic_vector(31 downto 0) := x"00000000";
	signal CM2 : std_logic_vector(31 downto 0);
	

	

	type vetor is array (natural range <>) of std_logic_vector(31 downto 0);
	signal key : vetor(0 to 7);

	type matriz is array (natural range <>, natural range <>) of std_logic_vector(3 downto 0);
	signal s_box : matriz(0 to 7, 0 to 15) := (
    (x"4", x"A", x"9", x"2", x"D", x"8", x"0", x"E", x"6", x"B", x"1", x"C", x"7", x"F", x"5", x"3"),
    (x"E", x"B", x"4", x"C", x"6", x"D", x"F", x"A", x"2", x"3", x"8", x"1", x"0", x"7", x"5", x"9"),
    (x"5", x"8", x"1", x"D", x"A", x"3", x"4", x"2", x"E", x"F", x"C", x"7", x"6", x"0", x"9", x"B"),
    (x"7", x"D", x"A", x"1", x"0", x"8", x"9", x"F", x"E", x"4", x"6", x"C", x"B", x"2", x"5", x"3"),
    (x"6", x"C", x"7", x"1", x"5", x"F", x"D", x"8", x"4", x"A", x"9", x"E", x"0", x"3", x"B", x"2"),
    (x"4", x"B", x"A", x"0", x"7", x"2", x"1", x"D", x"3", x"6", x"8", x"5", x"9", x"C", x"F", x"E"),
    (x"D", x"B", x"4", x"1", x"3", x"F", x"5", x"9", x"0", x"A", x"E", x"7", x"6", x"8", x"2", x"C"),
    (x"1", x"F", x"D", x"0", x"5", x"7", x"A", x"4", x"9", x"2", x"3", x"E", x"6", x"B", x"8", x"C")
);
type state is (idle, gost, ready);
	signal EA : state;

begin

--------------------------------------
-- MÁQUINA DE ESTADOS
--------------------------------------

--FSM: process(clock, reset)
--begin
--	if rising_edge(clock) then
--		if (reset = '1') then
--			EA <= idle;
--		else
--			EA <= EA;
--		end if;
--	end if;
--end process;

FSM_cases: process(clock, reset)
begin
	if rising_edge(clock) then
		if (reset = '1') then
			EA <= idle;
		else
		case EA is
			when idle =>
				if (start = '1') then
					EA <= gost;
				else
					EA <= idle;
				end if;

			when gost =>
				if(i = "11111" and j = "111") then
					EA <= ready;
				else
					EA <= gost;
				end if;

			when ready =>
				if (start = '1') then
					EA <= idle;
				else
					EA <= ready;
				end if;
		end case;
		end if;
	end if;
end process;

process(clock)
begin
	if rising_edge(clock) then
	if(EA = idle or EA = ready or atraso = '0') then
		i <= "00000";
	else
		if(j = "111") then
			i <= i + 1;
		end if;
		end if;
	end if;
end process;

process(clock)
begin
	if rising_edge(clock) then
		if(EA = idle or EA = ready) then
			j <= "111";
		else
			j <= j + 1;
	end if;
	end if;
end process;

--------------------------------------
-- GOST_ROUND
--------------------------------------
CM1 <= LSB + key(to_integer(unsigned(key_count)));
integerJ <= (4 * (7 - to_integer(unsigned(j))));
CM1aux <= std_logic_vector(shift_right(unsigned(CM1), integerJ));
Ni <= std_logic_vector(to_unsigned(to_integer(unsigned(CM1aux)) mod 16,Ni'length));
NiInteger <= to_integer(unsigned(Ni));
NiValor <= s_box(to_integer(unsigned(j)), NiInteger);
mask(31 downto 28) <= NiValor when (j = "000");
mask(27 downto 24) <= NiValor when (j = "001");
mask(23 downto 20) <= NiValor when (j = "010");
mask(19 downto 16) <= NiValor when (j = "011");
mask(15 downto 12) <= NiValor when (j = "100");
mask(11 downto 8) <= NiValor when (j = "101");
mask(7 downto 4) <= NiValor when (j = "110");
mask(3 downto 0) <= NiValor when (j = "111");
shift11 <= mask(20 downto 0) & mask(31 downto 21) when (j = "111") else (others => '0');
CM2 <= (MSB xor shift11);
process(clock, reset)
begin
	if rising_edge(clock) then
		if (reset = '1') then
			MSB <= (others => '0');
			LSB <= (others => '0');
		else
			if(EA = idle) then
				MSB <= data_i(63 downto 32);
				LSB <= data_i(31 downto 0);
			elsif (EA = gost) then
				if(atraso = '1' and j = "111") then
					MSB <= LSB;
				LSB <= CM2;
				end if;
			end if;
		end if;
	end if;
end process;


--------------------------------------
-- "ASSIGNS"
--------------------------------------

enc_count <= (not i(2 downto 0)) when (i(4 downto 3) = "11") else (i(2 downto 0));
dec_count <= (i(2 downto 0)) when (i < "01000") else (not i(2 downto 0));
key_count <= enc_count when enc_dec = '1' else dec_count;
key <= (key_i(31 downto 0), key_i(63 downto 32), key_i(95 downto 64), key_i(127 downto 96), key_i(159 downto 128), key_i(191 downto 160), key_i(223 downto 192), key_i(255 downto 224));
atraso <= '1' when (i = "00000" and j = "000" and EA = gost) else '0' when (EA = idle or EA = ready);

--------------------------------------
-- SAÍDAS
--------------------------------------

busy_o <= '1' when (EA = gost) else '0';
ready_o <= '1' when (EA = ready) else '0';
data_o <= MSB & LSB when (EA = ready) else (others => '0');

end architecture Arquitetura;
