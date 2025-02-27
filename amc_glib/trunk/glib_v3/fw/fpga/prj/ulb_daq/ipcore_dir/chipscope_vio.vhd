-------------------------------------------------------------------------------
-- Copyright (c) 2014 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : chipscope_vio.vhd
-- /___/   /\     Timestamp  : Mon Nov 24 16:02:12 Central Europe Standard Time 2014
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY chipscope_vio IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    ASYNC_IN: in std_logic_vector(15 downto 0);
    ASYNC_OUT: out std_logic_vector(15 downto 0);
    SYNC_IN: in std_logic_vector(15 downto 0);
    SYNC_OUT: out std_logic_vector(15 downto 0));
END chipscope_vio;

ARCHITECTURE chipscope_vio_a OF chipscope_vio IS
BEGIN

END chipscope_vio_a;
