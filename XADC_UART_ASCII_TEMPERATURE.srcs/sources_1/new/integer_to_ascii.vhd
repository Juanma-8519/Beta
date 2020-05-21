----------------------------------------------------------------------------------
-- Company: Innerspec
-- Engineer: Juanma Manchado
-- 
-- Create Date: 29/05/2020 11:55:13 AM
-- Design Name: 
-- Module Name:
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- This set of functions is used to convert a four digit integer to its 
-- corresponding ASCII characters to display its value from the serial port.
-- they are taken from  https://stackoverflow.com/questions/36824638/vhdl-how-to-efficiently-convert-integer-to-ascii-or-8-bit-slv/36846455#36846455
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

-- Package Declaration Section
package integer_to_ascii is

	type char_array is array (NATURAL RANGE <>) of std_logic_vector(7 downto 0);

	function get_ascii_array_from_int(i : integer range 0 to 9999) return 
		char_array;

	function get_ascii_array_from_int_hundreds (i : integer range 0 to 999) return 
		char_array;

	function get_ascii_array_from_int_tens (i : integer range 0 to 99) return
		char_array;

	function get_ascii_array_from_int_ones (i : integer range 0 to 9) return 
		std_logic_vector;
   
end package integer_to_ascii;
 
-- Package Body Section
package body integer_to_ascii is
 
function get_ascii_array_from_int_ones (i : integer range 0 to 9) return std_logic_vector is
        variable result : std_logic_vector(7 downto 0) := (x"30"); -- 0
    begin
        if i < 1 then
             result := x"30"; -- 0
        elsif i < 2 then
             result := x"31"; -- 1
        elsif i < 3 then
             result := x"32"; -- 2
        elsif i < 4 then
             result := x"33"; -- 3
        elsif i < 5 then
             result := x"34"; -- 4
        elsif i < 6 then
             result := x"35"; -- 5
        elsif i < 7 then
             result := x"36"; -- 6
        elsif i < 8 then
             result := x"37"; -- 7
        elsif i < 9 then
             result := x"38"; -- 8
        else
             result := x"39"; -- 9
        end if;
        return result;
    end get_ascii_array_from_int_ones;
    
function get_ascii_array_from_int_tens (i : integer range 0 to 99) return char_array is
        variable result : char_array (1 downto 0) := (x"30", x"30"); -- 00
    begin
        if i < 10 then
             result(0) := x"30"; -- 0
             result(1) := get_ascii_array_from_int_ones(i);
        elsif i < 20 then
             result(0) := x"31"; -- 1
             result(1) := get_ascii_array_from_int_ones(i-10);
        elsif i < 30 then
             result(0) := x"32"; -- 2
             result(1) := get_ascii_array_from_int_ones(i-20);
        elsif i < 40 then
             result(0) := x"33"; -- 3
             result(1) := get_ascii_array_from_int_ones(i-30);
        elsif i < 50 then
             result(0) := x"34"; -- 4
             result(1) := get_ascii_array_from_int_ones(i-40);
        elsif i < 60 then
             result(0) := x"35"; -- 5
             result(1) := get_ascii_array_from_int_ones(i-50);
        elsif i < 70 then
             result(0) := x"36"; -- 6
             result(1) := get_ascii_array_from_int_ones(i-60);
        elsif i < 80 then
             result(0) := x"37"; -- 7
             result(1) := get_ascii_array_from_int_ones(i-70);
        elsif i < 90 then
             result(0) := x"38"; -- 8
             result(1) := get_ascii_array_from_int_ones(i-80);
        else
             result(0) := x"39"; -- 9
             result(1) := get_ascii_array_from_int_ones(i-90);
        end if;
        return result;
    end get_ascii_array_from_int_tens;

function get_ascii_array_from_int_hundreds (i : integer range 0 to 999) return char_array is
        variable result : char_array (2 downto 0) := (x"30", x"30", x"30"); -- 000
    begin
        if i < 100 then
             result(0) := x"30"; -- 0
             result(2 downto 1) := get_ascii_array_from_int_tens(i);
        elsif i < 200 then
             result(0) := x"31"; -- 1
             result(2 downto 1) := get_ascii_array_from_int_tens(i-100);
        elsif i < 300 then
             result(0) := x"32"; -- 2
             result(2 downto 1) := get_ascii_array_from_int_tens(i-200);
        elsif i < 400 then
             result(0) := x"33"; -- 3
             result(2 downto 1) := get_ascii_array_from_int_tens(i-300);
        elsif i < 500 then
             result(0) := x"34"; -- 4
             result(2 downto 1) := get_ascii_array_from_int_tens(i-400);
        elsif i < 600 then
             result(0) := x"35"; -- 5
             result(2 downto 1) := get_ascii_array_from_int_tens(i-500);
        elsif i < 700 then
             result(0) := x"36"; -- 6
             result(2 downto 1) := get_ascii_array_from_int_tens(i-600);
        elsif i < 800 then
             result(0) := x"37"; -- 7
             result(2 downto 1) := get_ascii_array_from_int_tens(i-700);
        elsif i < 900 then
             result(0) := x"38"; -- 8
             result(2 downto 1) := get_ascii_array_from_int_tens(i-800);
        else
             result(0) := x"39"; -- 9
             result(2 downto 1) := get_ascii_array_from_int_tens(i-900);
        end if;
        return result;
    end get_ascii_array_from_int_hundreds;

function get_ascii_array_from_int(i : integer range 0 to 9999) return char_array is
        variable result : char_array (3 downto 0) := (x"30", x"30", x"30", x"30"); -- 0000
    begin
        if i >= 0 then
            if i < 1000 then
                result(0) := x"30"; -- 0
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i);
            elsif i < 2000 then
                result(0) := x"31"; -- 1
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-1000);
            elsif i < 3000 then
                result(0) := x"32"; -- 2
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-2000);
            elsif i < 4000 then
                result(0) := x"33"; -- 3
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-3000);
            elsif i < 5000 then
                result(0) := x"34"; -- 4
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-4000);
            elsif i < 6000 then
                result(0) := x"35"; -- 5
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-5000);
            elsif i < 7000 then
                result(0) := x"36"; -- 6
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-6000);
            elsif i < 8000 then
                result(0) := x"37"; -- 7
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-7000);
            elsif i < 9000 then
                result(0) := x"38"; -- 8
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-8000);
            else
                result(0) := x"39"; -- 9
                result(3 downto 1) := get_ascii_array_from_int_hundreds(i-9000);
            end if;
        else
            result := (x"6e", x"65", x"67", x"23"); -- "neg#" 
        end if;

        return result;

    end get_ascii_array_from_int;
 
end package body integer_to_ascii;
