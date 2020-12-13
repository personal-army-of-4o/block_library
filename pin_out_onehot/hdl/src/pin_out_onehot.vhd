-- pins out i-th but from 2d_bit_ar[j][i]
-- 5bit example:
--   \     |        0        |        1        |        2        |        3        |        4        |
--  i \    |  in   |   out   |  in   |   out   |  in   |   out   |  in   |   out   |  in   |   out   |
--  0      | 00001 |   0000  | 00001 |   0001  | 00001 |   0001  | 00001 |   0001  | 00001 |   0001  |
--  1      | 00010 |   0001  | 00010 |   0000  | 00010 |   0010  | 00010 |   0010  | 00010 |   0010  |
--  2      | 00100 |   0010  | 00100 |   0010  | 00100 |   0000  | 00100 |   0100  | 00100 |   0100  |
--  3      | 01000 |   0100  | 01000 |   0100  | 01000 |   0100  | 01000 |   0000  | 01000 |   1000  |
--  4      | 10000 |   1000  | 10000 |   1000  | 10000 |   1000  | 10000 |   1000  | 10000 |   0000  |
-- initially used in spw router to make sw independent of "forbid loopback routing" hw config

library ieee;
use ieee.std_logic_1164.all;


entity pin_out_onehot is
    port (
        iControl: in std_logic_vector; -- len = port_num*port_num

        oControl: out std_logic_vector -- len = port_num*(port_num-1)
    );
end entity;

architecture v1 of pin_out_onehot is

    constant cIw: natural := iControl'length;
    constant cOw: natural := oControl'length;
    constant cN: natural := cIw - cOw;

    signal sI: std_logic_vector (cIw-1 downto 0);
    signal sO: std_logic_vector (cOw-1 downto 0);

begin

    sI <= iControl;
    oControl <= sO;

    slices: for i in 0 to cN-1 generate

        signal sI_slice: std_logic_vector (cN-1 downto 0);
        signal sO_slice: std_logic_vector (cN-2 downto 0);

    begin

        sI_slice <= sI ((i+1)*cN-1 downto i*cN);

        first: if i = 0 generate
            sO_slice <= sI_slice (cN-1 downto 1);
        end generate;

        middle: if i > 0 and i < cN-1 generate
            sO_slice <= sI_slice (cN-1 downto i+1) & sI_slice (i-1 downto 0);
        end generate;

        last: if i = cN-1 generate
            sO_slice <= sI_slice (cN-2 downto 0);            
        end generate;

        sO ((i+1)*(cN-1)-1 downto i*(cN-1)) <= sO_slice;

    end generate;
    

end v1;