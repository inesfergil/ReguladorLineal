----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.05.2025 10:54:56
-- Design Name: 
-- Module Name: multiplicacion_BOOTH - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity multiplicacion is
    Port (
            clk         : in std_logic; 
            rst         : in std_logic; 
            start       : in std_logic;
            A           : in std_logic_vector(23 downto 0); 
            B           : in std_logic_vector(23 downto 0);
            result      : out std_logic_vector (47 downto 0); 
            finished    : out std_logic;
	        operando	: out std_logic
    );
end multiplicacion;

architecture Behavioral of multiplicacion is
    type state_tipo is (IDLE, CHECK, SHIFT, DONE); 
    signal state_act: state_tipo :=IDLE;  
    
    signal M        : signed (23 downto 0); 
    signal Q        : signed(23 downto 0); 
    signal Acc      : signed (23 downto 0) := (others => '0'); 
    signal Q_1      : std_logic :='0'; 
    signal count    : integer range 0 to 24 := 0; 
    
begin
    process(clk, rst)
    begin
        if rst='1' then
            state_act <=IDLE; 
            Acc <= (others =>'0'); 
            Q <= (others=> '0'); 
            Q_1 <= '0'; 
            count <= 0 ; 
            finished <= '0';
	        operando <= '0';
            result <= (others => '0');  
            M <= (others => '0'); 
        elsif rising_edge(clk) then
            case state_act is
                when IDLE => 
                   finished <= '0';
		           M <= signed(A);
                   Q <= signed(B);
                   Acc <= (others => '0');
                   Q_1 <= '0';
                   count <= 0;
                   if start = '1' then
                       state_act <= CHECK;
		           else
		              state_act <= IDLE;
                   end if;
                when CHECK =>
		            operando <= '1';
                    if Q(0) = '1' and Q_1 = '0' then 
                        Acc <= Acc - signed(M); 
                        state_act <= SHIFT; 
                    elsif Q(0) = '0' and Q_1 = '1' then
                        Acc <= Acc + signed (M); 
                        state_act <= SHIFT;
                    else 
                        state_act <= SHIFT; 
                    end if;                     
                when SHIFT =>
                    Q_1 <= Q(0); 
                    Q <= Acc(0) & Q(23 downto 1); 
                    Acc <= Acc(23) & Acc(23 downto 1); 
                    count <= count +1 ;
                    if count = 23 then
			            operando <= '0'; 
                        state_act <= DONE; 
                    else 
                        state_act <= CHECK; 
                    end if; 
                when DONE =>
                    result <= std_logic_vector(Acc(23 downto 0)& Q); 
                    finished <= '1'; 
                    state_act <=IDLE; 
                when others => 
                    state_act  <= IDLE; 
            end case; 
        end if;                                    
    end process; 
     
 end Behavioral; 