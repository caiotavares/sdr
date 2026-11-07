mod downlink;
mod detector;

use downlink::DF;

#[derive(Debug)]
struct ADSB {
    df: DF,
    ca: u8,
    icao: Vec<u8>,
    me: Vec<u8>,
    pi: Vec<u8>,
}

impl ADSB {
    pub fn apply(data: Vec<u8>) -> ADSB {
        let df = DF::apply(data[0] & 0b0001_1111);
        let ca = data[0] & 0b1110_0000;
        // let icao = 

        ADSB {}
    }
}

// Reads from constant stream over stdin, parses ADS-B and outputs on stdout
fn main() {
    println!("Hello, world!");
}
