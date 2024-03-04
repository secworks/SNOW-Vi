//======================================================================
//
// snow_vi_reference.go
// --------------------
// Reference implementation of the SNOW-Vi stream cipher.
// Used to drive the Verilog HW development.
//
// Joachim Strömbergson
// (c) 2024 Assured AB
// Marsaglia PRNG in Go.
// This should test bitmanipulation.
//
//======================================================================

package main
import "fmt"

type snow_vi_state struct {
	lfsr_a [16]uint32
	lfsr_b [16]uint32
	R1 [4]uint32
	R2 [4]uint32
	R3 [4]uint32
}


func PrintState(*snow_vi_state) {
	fmt.Println("Current state:")
	fmt.Println(snow_vi_state{})
}


func main() {
	fmt.Println("Creating a SNOW-Vi state.")
	my_state := snow_vi_state{}

	PrintState(&my_state)
}

//======================================================================
// EOF snow_vi_reference.go
//======================================================================
