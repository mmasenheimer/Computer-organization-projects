/* Implementation of a 32-bit adder in C.
 *
 * Author: Michael Masenheimer
 */

#include "sim1.h"

void execute_add(Sim1Data *obj) {
    int carry = obj->isSubtraction ? 1 : 0;
    obj->sum = 0;
    
    for (int i = 0; i < 32; i++) {
        int aBit = (obj->a >> i) & 1;
        int bBit = (obj->b >> i) & 1;
        // Extracting the ith bit from both a and b
        
        if (obj->isSubtraction) {
            bBit = !bBit;
            // Flip b's bits for subtraction

        } 
        
        int sum_bit = aBit ^ bBit ^ carry;
        // Just like java add program, use XOR to determine sum
        carry = (aBit & bBit) | (aBit & carry) | (bBit & carry);
        // Also for carry
        obj->sum |= (sum_bit << i);
    }
    
    obj->carryOut = carry;
    
    int msb_a = (obj->a >> 31) & 1;
    // Bit shifting and masking to determine most signifacnt bit
    int msb_b = obj->isSubtraction ? !((obj->b >> 31) & 1) : (obj->b >> 31) & 1;
    int msb_sum = (obj->sum >> 31) & 1;
    // Extracting the most significant bit here
    
    obj->aNonNeg = !msb_a;
    obj->bNonNeg = !(obj->b >> 31) & 1;  
    // The original b
    obj->sumNonNeg = !msb_sum;
    
    obj->overflow = obj->isSubtraction ? 
        (msb_a != !msb_b && msb_a != msb_sum) :
        (msb_a == msb_b && msb_a != msb_sum);
}