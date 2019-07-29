library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cordic_tb is
end entity;

architecture Behavioral of Cordic_tb is

constant  N    : natural := 16; --Ancho de la palabra
constant  ITER : natural := 16;--Numero de iteraciones

signal clk  : std_logic := '1';
signal rst  : std_logic := '1';
signal en_i : std_logic := '0';
signal x_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
signal y_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
signal z_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
signal dv_o : std_logic;
signal x_o  : std_logic_vector(N-1 downto 0);
signal y_o  : std_logic_vector(N-1 downto 0);
signal z_o  : std_logic_vector(N-1 downto 0);


constant clk_period : time := 20 ns;

begin

CLK_PROC: process
begin
  clk <= '1';
  wait for clk_period/2;
  clk <= '0';
  wait for clk_period/2;
end process;

RESET_PROC: process
begin
  rst <= '1';
  wait for clk_period * 5 + 1 ps;
  rst <= '0';
  wait;
end process;

STIM_PROC: process
begin
  en_i <= '0';
  wait for clk_period * 10 + 1 ps;
  en_i <= '1';    -- Primer vector a procesar
  x_i <= std_logic_vector(to_unsigned(0, N));   -- Poner el número a calcular.
  y_i <= std_logic_vector(to_unsigned(1000, N));   -- Poner el número a calcular.
  z_i <= std_logic_vector(to_unsigned(0, N));  -- Poner el número a calcular.
  -- wait for clk_period;    -- Segundo vector a procesar
  -- x_i <= std_logic_vector(to_unsigned(1, N));   -- Poner el número a calcular.
  -- y_i <= std_logic_vector(to_unsigned(0, N));   -- Poner el número a calcular.
  -- z_i <= std_logic_vector(to_unsigned(30, N));  -- Poner el número a calcular.
  -- wait for clk_period;    -- Tercer vector a procesar
  -- x_i <= std_logic_vector(to_unsigned(1, N));   -- Poner el número a calcular.
  -- y_i <= std_logic_vector(to_unsigned(0, N));   -- Poner el número a calcular.
  -- z_i <= std_logic_vector(to_unsigned(30, N));  -- Poner el número a calcular.
  -- wait for clk_period;    -- Cuarto vector a procesar
  -- x_i <= std_logic_vector(to_unsigned(1, N));   -- Poner el número a calcular.
  -- y_i <= std_logic_vector(to_unsigned(0, N));   -- Poner el número a calcular.
  -- z_i <= std_logic_vector(to_unsigned(30, N));  -- Poner el número a calcular.
  -- wait for clk_period;    -- Quinto vector a procesar
  -- x_i <= std_logic_vector(to_unsigned(1, N));   -- Poner el número a calcular.
  -- y_i <= std_logic_vector(to_unsigned(0, N));   -- Poner el número a calcular.
  -- z_i <= std_logic_vector(to_unsigned(30, N));  -- Poner el número a calcular.
  wait;
end process;

UUT: entity work.cordic
  generic map(
    N     => N,
    ITER  => ITER
  )
  port map(
    clk =>  clk,
    rst =>  rst,
    en_i  =>  en_i,
    x_i   =>  x_i,
    y_i   =>  y_i,
    z_i   =>  z_i,
    dv_o => dv_o,
    x_o  =>  x_o,
    y_o  =>  y_o,
    z_o  =>  z_o
  );

-- Se pueden agregar asserts para que la simulación termine si el resultado no
-- es el esperado.

end architecture;
