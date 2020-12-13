-- pins out i-th but from 2d_bit_ar[j][i]
-- initially used in spw router to make sw independent 
-- of "forbid loopback routing" hw config

library ieee;
use ieee.std_logic_1164.all;


entity pin_out_onehot is
    port (
        iControl: in std_logic_vector; -- len = port_num*port_num

        oControl: out std_logic_vector -- len = port_num*(port_num-1)
    );
end entity;

architecture v1 of pin_out_onehot is
begin

    -- TODO: add port length checks
    -- TODO: implement the logic

end v1;
