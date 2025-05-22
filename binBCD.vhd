----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 11:17:51
-- Design Name: 
-- Module Name: binBCD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin2bcd is
    Port (
        clk        : in std_logic;
        reset      : in std_logic;
        num_bin    : in std_logic_vector(11 downto 0); -- Entrada binaria (13 bits)
        segmentos  : out std_Logic_vector(6 downto 0);
        selector   : out std_logic_vector(3 downto 0)
    );
end bin2bcd;

architecture Behavioral of bin2bcd is

    -- Dígitos en BCD
    signal unidades, decenas, centenas, millares : unsigned(3 downto 0);
    signal BCD_digit : unsigned(3 downto 0);        --se usa en la parte de los displays

    -- Contador para multiplexado
    constant count_max_4khz : integer := 31; -- 125MHz / 4kHz (ajustar según tu reloj)
    signal count_4khz: integer range 0 to count_max_4khz;
    signal display_counter_en : std_logic;
    signal mycount : unsigned(1 downto 0);

    -- Conversión binario a BCD
    signal bcd : std_logic_vector(15 downto 0);

begin

    -- Conversión binario a BCD (Doble Dabble)
    process(clk, reset)
        variable z : std_logic_vector(15 downto 0);
        variable b : unsigned(11 downto 0);
        variable i : integer;
    begin
        if reset = '1' then
            bcd <= (others => '0');
        elsif rising_edge(clk) then
            b := unsigned(num_bin);
            z := (others => '0');

            --Doble Dablle de 13 bits
            for i in 0 to 11 loop
                
                if unsigned(z(3 downto 0)) > 4 then
                    z(3 downto 0) := std_logic_vector(unsigned(z(3 downto 0)) + 3);
                end if;
                if unsigned(z(7 downto 4)) > 4 then
                    z(7 downto 4) := std_logic_vector(unsigned(z(7 downto 4)) + 3);
                end if;
                if unsigned(z(11 downto 8)) > 4 then
                    z(11 downto 8) := std_logic_vector(unsigned(z(11 downto 8)) + 3);
                end if;
                if unsigned(z(15 downto 12)) > 4 then
                    z(15 downto 12) := std_logic_vector(unsigned(z(15 downto 12)) + 3);
                end if;

               
                z := z(14 downto 0) & b(11);
                b := b(10 downto 0) & '0';
            end loop;

            bcd <= z;
        end if;
    end process;

    -- Separación de dígitos
    unidades <= unsigned(bcd(3 downto 0));
    decenas  <= unsigned(bcd(7 downto 4));
    centenas <= unsigned(bcd(11 downto 8));
    millares <= unsigned(bcd(15 downto 12));

    
    -- Multiplexado de Displays
 
    process(clk, reset)
    begin
        if reset = '1' then
            count_4khz <= 0;
        elsif rising_edge(clk) then
            if count_4khz = count_max_4khz - 1 then
                count_4khz <= 0;
            else
                count_4khz <= count_4khz + 1;
            end if;
        end if;
    end process;

    display_counter_en <= '1' when (count_4khz = count_max_4khz - 1) else '0';

    process(clk, reset)
    begin
        if reset = '1' then
            mycount <= "00";
        elsif rising_edge(clk) then
            if display_counter_en = '1' then
                if mycount = "11" then
                    mycount <= "00";
                else
                    mycount <= mycount + 1;
                end if;
            end if;
        end if;
    end process;

    -- Selección de dígito
    selector <= "1000" when mycount = "00" else -- millares --7
                "0100" when mycount = "01" else -- centenas --b
                "0010" when mycount = "10" else -- decenas  --d
                "0001" when mycount = "11" else -- unidades --e
                "----";

    -- Selección del dígito a mostrar
    with mycount select
        BCD_digit <= millares when "00",
                     centenas when "01",
                     decenas  when "10",
                     unidades when "11",
                     "----" when others;

    -- Decodificador BCD a 7 segmentos
    with BCD_digit select
        segmentos <= "0000001" when "0000", -- 0
                     "1001111" when "0001", -- 1
                     "0010010" when "0010", -- 2
                     "0000110" when "0011", -- 3
                     "1001100" when "0100", -- 4
                     "0100100" when "0101", -- 5
                     "0100000" when "0110", -- 6
                     "0001111" when "0111", -- 7
                     "0000000" when "1000", -- 8
                     "0000100" when "1001", -- 9
                     "0000001" when others; 

end Behavioral;