library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity cordic_core is    
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
end entity;


architecture rtl of cordic_core is
    type signed_array is array (natural range <>) of signed(SIZE-1 downto 0);

    function gen_atan_table(size : positive; iterations : positive) return signed_array is
      variable table : signed_array(0 to ITERATIONS-1);
    begin
      for i in table'range loop
        table(i) := to_signed(integer(arctan(2.0**(-i)) * 2.0**size / MATH_2_PI), size);
      end loop;
  
      return table;
    end function;
  
    constant ATAN_TABLE : signed_array(0 to ITERATIONS-1) := gen_atan_table(SIZE, ITERATIONS);
  
    signal xr : signed(X'range);
    signal yr : signed(Y'range);
    signal zr : signed(Z'range);
  
    signal x_shift : signed(X'range);
    signal y_shift : signed(Y'range);
  
    subtype iter_count is integer range 0 to ITERATIONS;
  
    signal cur_iter : iter_count;
  begin
  
    cordic: process(Clock, Reset) is
      variable negative : boolean;
    begin
      if Reset = '1' then
        xr <= (others => '0');
        yr <= (others => '0');
        zr <= (others => '0');
        cur_iter <= 0;
        Result_valid <= '0';
        Busy <= '0';
      elsif rising_edge(Clock) then
        if Data_valid = '1' then
          xr <= X;
          yr <= Y;
          zr <= Z;
          cur_iter <= 0;
          Result_valid <= '0';
          Busy <= '1';
        else
          if cur_iter /= ITERATIONS then

            --if cur_iter(ITERATIONS) /= '1' then
            negative := yr(y'high) = '0';
            
            --if zr(z'high) = '1' then -- z or y is negative
            if negative then
              xr <= xr + y_shift; --(yr / 2**(cur_iter));
              yr <= yr - x_shift; --(xr / 2**(cur_iter));
              zr <= zr + ATAN_TABLE(cur_iter);
            else -- z or y is positive
              xr <= xr - y_shift; --(yr / 2**(cur_iter));
              yr <= yr + x_shift; --(xr / 2**(cur_iter));
              zr <= zr - ATAN_TABLE(cur_iter);
            end if;
  
            cur_iter <= cur_iter + 1;
            --cur_iter <= '0' & cur_iter(0 to ITERATIONS-1);
          end if;
  
          if cur_iter = ITERATIONS-1 then
            Result_valid <= '1';
            Busy <= '0';
          end if;
        end if;
  
      end if;
    end process;
  
    x_shift <= shift_right(xr, cur_iter);
    y_shift <= shift_right(yr, cur_iter);
  
  
    X_result <= xr;
    Y_result <= yr;
    Z_result <= zr;
  
end architecture;