----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/11/2017 11:37:39 PM
-- Design Name: 
-- Module Name: main_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

library work;
use work.integer_to_ascii.all;
use work.fsm_states.all;
 
entity main_tb is
end main_tb;

architecture Behavioral of main_tb is

--type Uart_Tx_State_type IS (IDLE, A, B, C, D, E);           -- Define the states

    -- Component declaration for the UUT
    component main is
        Port ( clk : in STD_LOGIC;
               --rst : in STD_LOGIC;
               vauxp6 : in STD_LOGIC;
               vauxn6 : in STD_LOGIC;
               --rxd : in STD_LOGIC;      -- UART recieve. Not (yet) being used.
               txd : out STD_LOGIC;     -- UART transmit.
               --rts : out STD_LOGIC;     -- Request to Send
               --cts : in STD_LOGIC;      -- Clear to Send
               uart_tx_led : out std_logic;
               adc_led : out std_logic
                             
               );
    end component;
    
    --Inputs
    signal clk     : std_logic := '0';
    signal rst     : std_logic := '1';
    signal vauxp6  : std_logic := '1';
    signal vauxn6  : std_logic := '0';
    
    --Outputs
    signal txd      : std_logic;
    signal uart_tx_led : std_logic;
    signal adc_led  : std_logic;
    
    signal adq_tick     : std_logic; 
    signal ADC_Data_Ready         : std_logic;
           
    signal analogData   : std_logic_vector(15 downto 0);           
    signal Analog_ASCII : char_array (7 downto 0);
           
    signal ASCII_byte_to_transmit   : STD_LOGIC_VECTOR(7 downto 0);
    signal index_byte_to_transmit   : STD_LOGIC_VECTOR(3 downto 0);
           
    signal uart_Ready         : std_logic := '0';
    
    signal Uart_Tx_State : Uart_Tx_State_Type;                  -- Create a signal that uses
    
    -- Clock period definition
    constant clk_period : time := 100 ns;
    
begin

    -- Instantiate the UUT
    UUT: main port map (
        clk         => clk,
        --rst       => rst,
        vauxp6      => vauxp6,
        vauxn6      => vauxn6,
        --vauxp7      => vauxp7,
        --vauxn7      => vauxn7,
        --vauxp14     => vauxp14,
        --vauxn14     => vauxn14,
        --vauxp15     => vauxp15,
        --vauxn15     => vauxn15,
        txd         => txd,
        uart_tx_led => uart_tx_led,
        adc_led     => adc_led  
    );
    
   -- Clock process definition
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    --stimulus process
    stim_proc: process
    begin
        rst <= '1';
        wait for 10*clk_period;
        rst <= '0';
        wait for clk_period*8;
        vauxp6  <= '0';
        vauxn6  <= '0';
        --vauxp7 <= '0';
        --vauxn7 <= '0';
        --vauxp14  <= '0';
        --vauxn14  <= '0';
        --vauxp15 <= '0';
        --vauxn15 <= '0';
        --wait for clk_period*8;
        wait for 20 ms;
        vauxp6  <= '0';
        vauxn6  <= '1';
        --vauxp7 <= '0';
        --vauxn7 <= '1';
        --vauxp14  <= '0';
        --vauxn14  <= '1';
        --vauxp15 <= '0';
        --vauxn15 <= '1';
        wait for 20 ms;
        vauxp6  <= '1';
        vauxn6  <= '0';
        --vauxp7 <= '1';
        --vauxn7 <= '0';
        --vauxp14  <= '1';
        --vauxn14  <= '0';
        --vauxp15 <= '1';
        --vauxn15 <= '0';
        wait for 20 ms;
        vauxp6  <= '0';
        vauxn6  <= '1';
        --vauxp7 <= '0';
        --vauxn7 <= '1';
        --vauxp14  <= '0';
        --vauxn14  <= '1';
        --vauxp15 <= '0';
        --vauxn15 <= '1';
        wait for 20 ms;
        vauxp6  <= '1';
        vauxn6  <= '0';
        --vauxp7 <= '1';
        --vauxn7 <= '0';
        --vauxp14  <= '1';
        --vauxn14  <= '0';
        --vauxp15 <= '1';
        --vauxn15 <= '0';
        wait for 20 ms;
        vauxp6  <= '0';
        vauxn6  <= '1';
        --vauxp7 <= '0';
        --vauxn7 <= '1';
        --vauxp14  <= '0';
        --vauxn14  <= '1';
        --vauxp15 <= '0';
        --vauxn15 <= '1';
        wait for 20 ms;
        vauxp6  <= '1';
        vauxn6  <= '0';
        --vauxp7 <= '1';
        --vauxn7 <= '0';
        --vauxp14  <= '1';
        --vauxn14  <= '0';
        --vauxp15 <= '1';
        --vauxn15 <= '0';
        wait for 20 ms;
        vauxp6  <= '0';
        vauxn6  <= '1';
        --vauxp7 <= '0';
        --vauxn7 <= '1';
        --vauxp14  <= '0';
        --vauxn14  <= '1';
        --vauxp15 <= '0';
        --vauxn15 <= '1';
        wait for 20 ms;
        vauxp6  <= '1';
        vauxn6  <= '0';
        --vauxp7 <= '1';
        --vauxn7 <= '0';
        --vauxp14  <= '1';
        --vauxn14  <= '0';
        --vauxp15 <= '1';
        --vauxn15 <= '0';
        wait for 20 ms;
        vauxp6  <= '0';
        vauxn6  <= '1';
        --vauxp7 <= '0';
        --vauxn7 <= '1';
        --vauxp14  <= '0';
        --vauxn14  <= '1';
        --vauxp15 <= '0';
        --vauxn15 <= '1';
        wait for 20 ms;
        vauxp6  <= '1';
        vauxn6  <= '0';
        --vauxp7 <= '1';
        --vauxn7 <= '0';
        --vauxp14  <= '1';
        --vauxn14  <= '0';
        --vauxp15 <= '1';
        --vauxn15 <= '0';
        wait for 20 ms;
        vauxp6  <= '0';
        vauxn6  <= '1';
        --vauxp7 <= '0';
        --vauxn7 <= '1';
        --vauxp14  <= '0';
        --vauxn14  <= '1';
        --vauxp15 <= '0';
        --vauxn15 <= '1';
        wait for 20 ms;
        vauxp6  <= '1';
        vauxn6  <= '0';
        --vauxp7 <= '1';
        --vauxn7 <= '0';
        --vauxp14  <= '1';
        --vauxn14  <= '0';
        --vauxp15 <= '1';
        --vauxn15 <= '0';

        wait;
    end process;

end Behavioral;



