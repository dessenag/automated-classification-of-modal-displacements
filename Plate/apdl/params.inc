! Parameters of the tapered cantilever plate (SI units)
! Axes: x aft (leading edge to trailing edge), y spanwise outboard, z up.
! Origin at the root mid-chord. Straight leading edge at x = -C_ROOT/2;
! the trailing edge is swept, so the planform is not symmetric about the y axis.

L_SPAN = 1.0          ! span, root to tip [m]
C_ROOT = 0.300        ! root chord [m]
TAPER  = 0.3          ! tip chord / root chord [-]
THICK  = 0.002        ! plate thickness [m]

! Aluminium 6082-T6 (as for the spar of the XB-2 wing)
E_MOD  = 70.0e9       ! Young's modulus [Pa]
NU     = 0.33         ! Poisson's ratio [-]
RHO    = 2700.0       ! density [kg/m^3]

! Mapped mesh: divisions along the chord and along the span
N_CHORD = 156
N_SPAN  = 800

N_MODES = 8           ! number of modes extracted
