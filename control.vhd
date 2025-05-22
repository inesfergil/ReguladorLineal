----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 14:19:16
-- Design Name: 
-- Module Name: control - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
    Port (
        clk_c               : in std_logic; 
        rst_c               : in std_logic;
        ready               : in std_logic;
        finished_c          : in std_logic;
	    operando_c	        : in std_logic;
        start_c             : out std_logic;
        result_c            : in std_logic_vector (47 downto 0);
        A_c                 : in std_logic_vector(23 downto 0);
        B_c                 : in std_logic_vector(23 downto 0);
        resultado_fin       : out std_logic_vector (11 downto 0);
        Multiplicando       : out std_logic_vector(23 downto 0);
        Multiplicador       : out std_logic_vector(23 downto 0);
        ovf_1ms             : in std_logic; 
        ovf_2s              : in std_logic 
     );
end control;

architecture Behavioral of control is
    signal C_c              : std_logic_vector(23 downto 0) := "000000000000000101010001";
    signal count_1          : integer:=0;
    signal ovf_1            : std_logic := '0';
    signal resultado_casi    : std_logic_vector (23 downto 0);
        
    type state_tipo is (IDLE,MULTIPLICACION1, MULTIPLICACION2, DONE); 
    signal state_act: state_tipo :=IDLE; 
    
begin
    process(clk_c, rst_c)
    begin
    if rst_c='1' then
        resultado_fin <= (others => '0');
        Multiplicando <= (others => '0');
        Multiplicador <= (others => '0');
        start_c <= '0';                
    elsif rising_edge(clk_c) then
        case state_act is
        when IDLE =>
            start_c <= '0';
            if ready = '0' then
                Multiplicando <= (others => '0');
                Multiplicador <= (others => '0');
		state_act <= IDLE;
            else
                state_act <= MULTIPLICACION1;
            end if;
        when MULTIPLICACION1 =>
            Multiplicando <= A_c;
            Multiplicador <= B_c;
            if ovf_1 = '1' then 
	           start_c <= '1';
	        end if;
            if operando_c = '1' then
		      start_c <= '0';
	        end if;
            if finished_c = '1' then
                start_c <= '0';
                state_act <= MULTIPLICACION2;
            else
		--No se si esto la va a liar, creo que va a hacer muchos pulsos de start
		state_act <= MULTIPLICACION1;
	    end if;    
        when MULTIPLICACION2 =>
            Multiplicando <= C_c;
            Multiplicador <= result_c(23 downto 0);
            if ovf_1 = '1' then 
	           start_c <= '1';
	        end if;
	    if operando_c = '1' then
		start_c <= '0';
	    end if;
            if finished_c = '1' then
                start_c <= '0';
                state_act <= DONE;
            end if; 
        when DONE =>
            resultado_casi <= result_c(47 downto 24); 
            resultado_fin <= resultado_casi(11 downto 0);
            if ovf_1ms = '1' then
                state_act <= IDLE;
            end if;    
        end case;    
    end if;     
    end process;
    
    process(clk_c, rst_c)
    begin
        if rising_edge(clk_c) then
            if rst_c = '1' then
                count_1 <= 0; 
                ovf_1 <= '0';
            elsif count_1 > 1 then
               count_1 <= 0; 
               ovf_1  <= '1'; -- Pulso alto por un ciclo 
           else
            count_1 <= count_1 + 1;
            ovf_1 <= '0';
           end if;
        end if;    
    end process;  
    
end Behavioral;

