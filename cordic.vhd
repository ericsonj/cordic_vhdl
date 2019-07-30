library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic is
  generic(
    N : natural := 16; --Ancho de la palabra
    ITER : natural := 12);--Numero de iteraciones
  port(
    clk : in std_logic;
    rst : in std_logic;
    en_i : in std_logic;
    x_i  : in std_logic_vector(N-1 downto 0);
    y_i  : in std_logic_vector(N-1 downto 0);
    z_i  : in std_logic_vector(N-1 downto 0);
    dv_o : out std_logic;
    x_o  : out std_logic_vector(N-1 downto 0);
    y_o  : out std_logic_vector(N-1 downto 0);
    z_o  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture structural of cordic is

  component cordic_core is
  generic (
    SIZE        :positive;
    ITERATIONS  :positive
  );
  port (

    Clock : in std_ulogic;
    Reset : in std_ulogic;

    Data_valid   : in std_ulogic;  --# Load new input data
    Busy         : out std_ulogic; --# Generating new result
    Result_valid : out std_ulogic; --# Flag when result is valid

    X : in signed(SIZE-1 downto 0);
    Y : in signed(SIZE-1 downto 0);
    Z : in signed(SIZE-1 downto 0);
    
    X_result : out signed(SIZE-1 downto 0);
    Y_result : out signed(SIZE-1 downto 0);
    Z_result : out signed(SIZE-1 downto 0)

  );
  end component;

  signal en_ii : std_ulogic := '0';
  signal is_busy : std_ulogic;

  signal xt_o  : signed(N-1 downto 0);
  signal yt_o  : signed(N-1 downto 0);
  signal zt_o  : signed(N-1 downto 0);


  begin

  enable : process(clk, en_i, is_busy) is
  begin 
    if en_i = '1' and is_busy = '0' then
      en_ii <= '1';
    elsif is_busy = '1' then
      en_ii <= '0';
    end if;
  end process;

  CORD : cordic_core 
    generic map (
      SIZE => N,
      ITERATIONS  => ITER
    )
    port map (
      Clock           => clk,
      Reset           => rst,
      Data_valid      => en_ii,
      Busy            => is_busy,
      Result_valid    => dv_o,

      X               => signed(x_i),
      Y               => signed(y_i),
      Z               => signed(z_i),

      X_result        => xt_o,
      Y_result        => yt_o,
      Z_result        => zt_o
    );

    x_o <= std_logic_vector(xt_o);
    y_o <= std_logic_vector(yt_o);
    z_o <= std_logic_vector(zt_o);

end architecture;
