#[derive(Debug)]
pub enum DF {
    ShortAirAirSurveillance,
    SurveillanceAltitudeReply,
    SurveillanceIdentityReply,
    AllCallReply,
    LongAirAirSurveillance,
    ExtendedSquitter,
    ExtendedSquitterNoTransponder,
    MilitaryExtendedSquitter,
    CommBAltitudeReply,
    CommBIdentityReply,
    CommDELM,
}

impl DF {
    pub fn apply(data: u8) -> DF {
        match data {
            0x00 => DF::ShortAirAirSurveillance,
            0x04 => DF::SurveillanceAltitudeReply,
            0x05 => DF::SurveillanceIdentityReply,
            0x11 => DF::AllCallReply,
            0x17 => DF::ExtendedSquitter,
            0x18 => DF::ExtendedSquitterNoTransponder,
            0x20 => DF::CommBAltitudeReply,
            0x21 => DF::CommBIdentityReply,
            0x24 => DF::CommDELM,
            _ => panic!("Unknown downlink format"),
        }
    }
}

enum CA {
    Level1,
    Level2OnGround,
    Level2Airborne,
    Level2
}

impl CA {}
