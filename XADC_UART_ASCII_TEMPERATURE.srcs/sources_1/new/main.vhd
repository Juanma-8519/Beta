----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Juan Manuel Manchado
-- 
-- Create Date: 21/05/2020 11:55:13 AM
-- Design Name: 
-- Module Name: main - Behavioral
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


library work;
use work.integer_to_ascii.all;
use work.fsm_states.all;

           

entity main is

--type Uart_Tx_State_type IS (IDLE, A, B, C, D, E);           -- Define the states
    
    generic (ADC_Frec : integer := 2; 
             Serial_Baudrate : integer := 115200;
             clk_freq : integer := 100000000
    );
    Port ( clk          : in STD_LOGIC;
           vauxp6       : in STD_LOGIC;
           vauxn6       : in STD_LOGIC;
           --vauxp7       : in std_logic;
           --vauxn7       : in std_logic;
           --vauxp14      : in std_logic;
           --vauxn14      : in std_logic;
           --vauxp15      : in std_logic;
           --vauxn15      : in std_logic;

           txd          : out STD_LOGIC;     -- UART transmit.

           uart_tx_led  : out std_logic;
           adc_led      : out std_logic
           
--           adq_tick               : inout std_logic; 
--           ADC_Data_Ready         : inout std_logic;
--           Uart_Send_Data         : inout std_logic;
           
--           analogData   : inout std_logic_vector(15 downto 0) := (others => '0');           
--           Analog_ASCII : inout char_array (7 downto 0) := (0 => (others => '0'), 1 => (others => '0'), 2 => (others => '0'),  3 => (others => '0'), 4 => (others => '0'), 5 => (others => '0'), 6 => (others => '0'), 7 => (others => '0'));
           --Analog_ASCII : inout char_array (7 downto 0) : = (others => (others => (others => '0')));
           --Analog_ASCII : inout char_array (7 downto 0) : = (others => (others => (others => '0')));
           
--           ASCII_byte_to_transmit   : inout STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
--           index_byte_to_transmit   : inout STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
           
--           Uart_Ready        : inout std_logic := '0';
           
--           Uart_Tx_State : inout Uart_Tx_State_Type := IDLE                 -- Create a signal that uses
           --bit_tick          : inout std_logic := '0'
           
           );
end main;

architecture Behavioral of main is

    signal rst          : std_logic;
    --signal reset_sr     : std_logic_vector(3 downto 0) := (others => '1');

    component xadc_wiz_1 is
       port
       (
        daddr_in        : in  STD_LOGIC_VECTOR(6 downto 0);      -- Address bus for the dynamic reconfiguration port
        den_in          : in  STD_LOGIC;                         -- Enable Signal for the dynamic reconfiguration port
        di_in           : in  STD_LOGIC_VECTOR(15 downto 0);     -- Input data bus for the dynamic reconfiguration port
        dwe_in          : in  STD_LOGIC;                         -- Write Enable for the dynamic reconfiguration port
        do_out          : out  STD_LOGIC_VECTOR(15 downto 0);    -- Output data bus for dynamic reconfiguration port
        drdy_out        : out  STD_LOGIC;                        -- Data ready signal for the dynamic reconfiguration port
        dclk_in         : in  STD_LOGIC;                         -- Clock input for the dynamic reconfiguration port
        reset_in        : in  STD_LOGIC;                         -- Reset signal for the System Monitor control logic
        vauxp6          : in  STD_LOGIC;                         -- Auxiliary Channel 2
        vauxn6          : in  STD_LOGIC;
        vauxp7          : in  STD_LOGIC;                         -- Auxiliary Channel 3
        vauxn7          : in  STD_LOGIC;
        vauxp14         : in  STD_LOGIC;                         -- Auxiliary Channel 10
        vauxn14         : in  STD_LOGIC;
        vauxp15         : in  STD_LOGIC;                         -- Auxiliary Channel 11
        vauxn15         : in  STD_LOGIC;
        busy_out        : out  STD_LOGIC;                        -- ADC Busy signal
        channel_out     : out  STD_LOGIC_VECTOR(4 downto 0);     -- Channel Selection Outputs
        eoc_out         : out  STD_LOGIC;                        -- End of Conversion Signal
        eos_out         : out  STD_LOGIC;                        -- End of Sequence Signal
        alarm_out       : out STD_LOGIC;                         -- OR'ed output of all the Alarms
        vp_in           : in  STD_LOGIC;                         -- Dedicated Analog Input Pair
        vn_in           : in  STD_LOGIC
    );
    end component;

    signal adq_count    : unsigned(31 downto 0) := (others => '0');            -- Used to frequency divide the core clock to the adquisition clock frequency.
    signal adq_tick     : std_logic := '0';                                    -- Adquisition clock tick
    constant adq_rate   : unsigned(31 downto 0) := to_unsigned(ADC_Frec,32);   -- 1, for 1 Hz clock. Maximum Adq_Rate = 11.520
    signal analogData   : std_logic_vector(15 downto 0);

    signal Analog_ASCII : char_array (7 downto 0);

    --signal eoc : std_logic;
    --signal eos : std_logic;

    signal ADC_Data_Ready         : std_logic;
    constant daddr      : std_logic_vector(6 downto 0) := (others => '0'); -- temp is 00h addres --  "0010011"; -- hard selecting channel 3, IE JXADC pin 1 & 7 (rightmost, looking into the connector)
    --constant daddr      : std_logic_vector(6 downto 0) := "0010110"; --  "0010110"; canal 6 -- hard selecting channel 3, IE JXADC pin 1 & 7 (rightmost, looking into the connector)
                                                                -- will sequence them later.
    
    
    signal enable       : std_logic;
    signal channel_out  : std_logic_vector(4 downto 0); -- channel selection
    --signal alarm_out  : std_logic;
    
    signal vauxp7       : std_logic;
    signal vauxn7       : std_logic;
    signal vauxp14      : std_logic;
    signal vauxn14      : std_logic;
    signal vauxp15      : std_logic;
    signal vauxn15      : std_logic;
    
    component UART_TX_CTRL is
    Port ( SEND    : in  STD_LOGIC;
           DATA    : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK     : in  STD_LOGIC;
           READY   : out  STD_LOGIC;
           UART_TX : out  STD_LOGIC);
    end component;

    signal Uart_Send_Data           : std_logic := '0';
    signal ASCII_byte_to_transmit   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal index_byte_to_transmit   : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal Uart_Ready               : std_logic := '0';
    signal tx_count                 : unsigned(12 downto 0) := (others => '0');             -- Used to frequency divide the core clock to the transmit clock frequency.
    signal bit_tick                 : std_logic := '0';                                     -- Transmit clock tick.
    constant baud_rate              : unsigned(31 downto 0) := to_unsigned(Serial_Baudrate,32);         -- 9600 baud

    constant clk_rate               : unsigned(31 downto 0) := to_unsigned(clk_freq,32);   -- 100000000, for 100 MHz clock.

    signal end_of_transmission : std_logic := '0'; 
    
   
	signal Uart_Tx_State : Uart_Tx_State_Type;                  -- Create a signal that uses

begin

    uart_tx : UART_TX_CTRL port map (
        SEND            => Uart_Send_Data,
        DATA            => ASCII_byte_to_transmit,
        CLK      	    => clk,
        READY           => Uart_Ready,
        UART_TX         => txd);

    --You may also need to connect "den_in" to something that isn't always asserted (simulation fails with a DRC check):
    
    adc : xadc_wiz_1 port map (
        daddr_in        => daddr,
        --den_in        => bit_tick, -- was '1' this will read the XADC register '9600' times a second
        den_in          => adq_tick, -- this will read the XADC register 'adq_freq' times a second
        di_in           => (others => '0'),
        dwe_in          => '0',
        do_out          => analogData,
        drdy_out        => ADC_Data_Ready,
        dclk_in         => clk,
        reset_in        => rst,
        -- JXADC pins
        -- physical numbering and signals
        -- VCC GND 11  2   10  3
        -- 6   5   4   3   2   1 -- Positive
        -- 12  11  10  9   8   7 -- Negative
        vauxp6          => vauxp6, 
        vauxn6          => vauxn6,
        vauxp7          => vauxp7,
        vauxn7          => vauxn7,
        vauxp14         => vauxp14,
        vauxn14         => vauxn14,
        vauxp15         => vauxp15,
        vauxn15         => vauxn15,
        busy_out        => adc_led,
        channel_out     => channel_out,
        eoc_out         => enable,
        eos_out         => open,
        alarm_out       => open,
        vp_in           => '0',
        vn_in           => '0'
        );
    
    --enable <= '1';
    --rst <= reset_sr(0);
     uart_tx_led <= Uart_Ready;
    
    -- generates the pulses to read the ADC
adq_tick_proc:  process(clk)
    begin
        if rising_edge(clk) then
            if adq_count = clk_rate/adq_rate-1 then
                adq_count <= (others => '0');
                adq_tick  <= '1';

            else
                adq_count <= adq_count + 1;
                adq_tick <= '0';
            end if;
        end if;
    end process;
    
-- Generate the signal sequence to write the serial port
Usart_Send_Data_proc:  process (clk, ADC_Data_Ready, Uart_Ready) 
	variable mVolts : integer;
	variable Temp   : integer;
  	begin 
    	If (ADC_Data_Ready = '1') then            -- Upon reset, set the state to A
			     Uart_Tx_State <= A;
 
    	elsif rising_edge(clk) then       -- if there is a rising edge of the
		                                  -- clock, then do the stuff below
       		case Uart_Tx_State is
	              when IDLE =>
	 			     Uart_Tx_State <= IDLE;		
		          when A =>
		             -- Temp = (value * 503.975)/4096 - 273.15
                     --      =  (2499* 503.975)/4096 - 273.15
                     --      = 34.3 degrees C
			         mVolts :=to_integer(unsigned(analogData(15 downto 4)))*12/100;
			         --mVolts := to_integer(to_unsigned(analogData(15 downto 4)))/X"FFF";
    			     Analog_ASCII (3 downto 0) <= get_ascii_array_from_int(mVolts);
			         --Analog_ASCII (4) <="01101101"; --0x6D 'm'
			         Analog_ASCII (4) <="00100010"; --0x20 ''
			         --Analog_ASCII (5) <="01010110"; --0x56 'V'
			         Analog_ASCII (5) <="01001011"; --0x4B 'K'
			         Analog_ASCII (6) <="00001010"; --0x0A 'NL'
			         Analog_ASCII (7) <="00001101"; --0x0D 'CR' 
			         index_byte_to_transmit <= (others => '0');
			         Uart_Tx_State <= B; 
		          when B => 
			         --ASCII_byte_to_transmit <= Analog_ASCII(1))); 
			         ASCII_byte_to_transmit <= Analog_ASCII(to_integer(unsigned(index_byte_to_transmit)));
			         Uart_Tx_State <= C;
		          when C => 
			         if Uart_Ready = '1' then 
				        Uart_Send_Data <= '1'; 
				        Uart_Tx_State <= D; 
			         else
				        Uart_Tx_State <= C;
			         end if;	
		          when D => 
			         Uart_Send_Data <= '0';
			         Uart_Tx_State <= E;
			      when E =>
			         if Uart_Ready = '1' then
			             if unsigned(index_byte_to_transmit) < 7 then
			                 index_byte_to_transmit <= std_logic_vector( unsigned(index_byte_to_transmit)+1);
			                 Uart_Tx_State <= B;
			             else 
			                 Uart_Tx_State <= IDLE;
			             end if;
			         end if;
		          when others =>
			         Uart_Tx_State <= IDLE;
	           end case; 
        end if; 
  end process;
 
end behavioral;