-- Address decode logic for ipbus fabric
--
-- This file will be AUTOGENERATED from the address table - do not hand edit
--
-- We assume the synthesis tool is clever enough to recognise exclusive conditions
-- in the if statement.
--
-- Dave Newbold, February 2011

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;

package ipbus_addr_decode is

  function ipbus_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer;

end ipbus_addr_decode;

package body ipbus_addr_decode is

  function ipbus_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
    variable sel : integer;
  begin
		if std_match(addr, "-------------------1------------") then
			sel := 2;
		elsif std_match(addr, "-------------------0----------1-") then
			sel := 3;
		elsif std_match(addr, "-------------------0----------00") then
			sel := 0;
		elsif std_match(addr, "-------------------0----------01") then
			sel := 1;
		else
			sel := 99;
		end if;
		return sel;
	end ipbus_addr_sel;
 
end ipbus_addr_decode;
