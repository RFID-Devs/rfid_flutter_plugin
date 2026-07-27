/// RFID module working frequency bands <br/>
/// RFID模块工作频段
enum RfidFrequency {
  /// China frequency range (840~845MHz)
  // china1(0x01),

  /// China Plus frequency range (920~925MHz)
  china(0x02),

  /// ETSI Lower frequency range (865~868MHz)
  etsi_lower(0x04),

  /// United States frequency range (902~928MHz)
  usa(0x08),

  /// Korea frequency range (917~923MHz)
  korea(0x16),

  /// Japan frequency range (916.8~920.8MHz)
  japan(0x32),

  /// South Africa frequency range (915~919MHz)
  southAfrica(0x33),

  /// China Taiwan frequency range (920~928MHz)
  taiwan(0x34),

  /// Vietnam frequency range (918~923MHz)
  vietnam(0x35),

  /// Peru frequency range (915MHz~928MHz)
  peru(0x36),

  /// Russia frequency range (860~867.6MHz)
  russia(0x37),

  /// Malaysia frequency range (919~923MHz)
  malaysia(0x3B),

  /// Brazil frequency range (902~907.5, 915~928 MHz)
  brazil(0x3C),

  /// ETSI Upper frequency range (915~921MHz)
  etsi_upper(0x3D),

  /// Australia frequency range (920~926MHz)
  australia(0x3E),

  /// Indonesia frequency range (920~923MHz)
  indonesia(0x3F),

  /// Israel frequency (915~917MHz)
  israel(0x40),

  /// China Hong Kong frequency (920~925MHz)
  hongKong(0x41),

  /// New Zealand frequency (920~928MHz)
  newZealand(0x42);

  /// Constructor to initialize RfidFrequency parameters <br/>
  /// 构造函数，初始化 RfidFrequency 参数
  const RfidFrequency(this.value);

  /// The numeric value of the frequency band
  /// 频段的数值
  final int value;

  /// Get frequency description
  /// 获取频段描述
  String get description {
    switch (this) {
      case china:
        return 'China';
      case etsi_lower:
        return 'ETSI Lower';
      case usa:
        return 'United States';
      case korea:
        return 'Korea';
      case japan:
        return 'Japan';
      case southAfrica:
        return 'South Africa';
      case taiwan:
        return 'Taiwan';
      case vietnam:
        return 'Vietnam';
      case peru:
        return 'Peru';
      case russia:
        return 'Russia';
      case malaysia:
        return 'Malaysia';
      case brazil:
        return 'Brazil';
      case etsi_upper:
        return 'ETSI Upper';
      case australia:
        return 'Australia';
      case indonesia:
        return 'Indonesia';
      case israel:
        return 'Israel';
      case hongKong:
        return 'Hong Kong';
      case newZealand:
        return 'New Zealand';
    }
  }

  /// Find frequency by value
  /// 根据值查找频段
  static RfidFrequency? fromValue(int value) {
    for (RfidFrequency frequency in RfidFrequency.values) {
      if (frequency.value == value) {
        return frequency;
      }
    }
    return null;
  }
}
