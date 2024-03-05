# snow_vi

## Status
Just Started. Does not work. **Do. NOT. Use.**

## Introduction
This is a hardware implementation of the [SNOW-Vi stream
cipher](https://eprint.iacr.org/2021/236.pdf) (PDF).  One needs to
read the [SNOW-V stream cipher
paper](https://tosc.iacr.org/index.php/ToSC/article/view/8356/7705)
(pdf) to understand the SNOW-Vi paper, for example how the cipher is
initialized, and how the AEAD mode works.

The repository contains a reference C model written by Patrik Ekdahl,
one of the authors of SNOW-Vi.The model can be found in
src/model/reference_model.

## Implementation notes
The core is a fairly straight forward implementation. It will use two
separate AES-round cores to allow a singe cycle FSM update. The AES round
is from my  [AES core](https://github.com/secworks/aes).
