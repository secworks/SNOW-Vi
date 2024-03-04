# snow_vi

## Status
Just Started. Does not work. **DO. Not. Use.**

## Introduction
This is a hardware implementation of the [SNOW-Vi stream cipher](https://eprint.iacr.org/2021/236.pdf) (PDF).
One needs to read the [SNOW-V stream cipher paper](https://tosc.iacr.org/index.php/ToSC/article/view/8356/7705) (pdf) to understand the SNOW-Vi paper, for example how the cipher is initialized, and how the AEAD mode works.

There is (will be) a reference implementation written in Goi to be used to drive test vectors.

This is a fairly straight forward implementation. It will use two separate AES-round cores to allow a singe cycle FSM update.
