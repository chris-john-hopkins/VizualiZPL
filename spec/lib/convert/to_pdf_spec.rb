# frozen_string_literal: true

require 'vizualizpl'

# rubocop:disable Metrics/BlockLength
RSpec.describe Vizualizpl::Convert::ToPdf do
  let(:zpl) do
    "^XA
    ^FX Top section with logo, name and address.
    ^CF0,60
    ^FO50,50^GB100,100,100^FS
    ^FO75,75^FR^GB100,100,100^FS
    ^FO93,93^GB40,40,40^FS
    ^FO220,50^FDIntershipping, Inc.^FS
    ^CF0,30
    ^FO220,115^FD1000 Shipping Lane^FS
    ^FO220,155^FDShelbyville TN 38102^FS
    ^FO220,195^FDUnited States (USA)^FS
    ^FO50,250^GB700,3,3^FS

    ^FX Second section with recipient address and permit information.
    ^CFA,30
    ^FO50,300^FDJohn Doe^FS
    ^FO50,340^FD100 Main Street^FS
    ^FO50,380^FDSpringfield TN 39021^FS
    ^FO50,420^FDUnited States (USA)^FS
    ^CFA,15
    ^FO600,300^GB150,150,3^FS
    ^FO638,340^FDPermit^FS
    ^FO638,390^FD123456^FS
    ^FO50,500^GB700,3,3^FS

    ^FX Third section with bar code.
    ^BY5,2,270
    ^FO100,550^BC^FD12345678^FS

    ^FX Fourth section (the two boxes on the bottom).
    ^FO50,900^GB700,250,3^FS
    ^FO400,900^GB3,250,3^FS
    ^CF0,40
    ^FO100,960^FDCtr. X34B-1^FS
    ^FO100,1010^FDREF1 F00B47^FS
    ^FO100,1060^FDREF2 BL4H8^FS
    ^CF0,190
    ^FO470,955^FDCA^FS

    ^XZ"
  end

  it 'has a version number' do
    puts Vizualizpl::Convert::ToPdf.new(zpl: zpl).perform
  end

  describe 'toshi label' do
    let(:zpl) do
      '^XA          ^FX Top section with logo, name and address.          ^FO50,50^GFA,1045,1045,19,Y078,Y07C,Y0EE,X01C7,X0383,X03038,,:::::::::JFCK0FEM0FFK03I07J01C,JFEJ03FF8K03FFCJ03I07J01C,JFCJ0IFEK07IFJ03I07J01C,00EK01F01FK0F00EJ03I07J01C,00EK01C0078J0EM03I07J01C,00EK038003CI01CM03I07J01C,00EK078001CI01CM03I07J01C,00EK07I01CI01CM03I07J01C,00EK07J0EJ0EM03I07J01C,00EK0EJ0EJ0F8L03I07J01C,00EK0EJ0EJ07FEK03JFJ01C,00EK0EJ0EJ03FF8J03JFJ01C,00EK0EJ0EK07FEJ03JFJ01C,00EK0EJ0EL01FJ03I07J01C,00EK07J0EM0FJ03I07J01C,00EK07I01CM07J03I07J01C,00EK078001CM07J03I07J01C,00EK0380038M07J03I07J01C,00EK01C0078J0800FJ03I07J01C,00EK01F01FJ01E01EJ03I07J01C,00EL0IFEJ01IFCJ03I07J01C,00EL03FF8K07FF8J03I07J01C,00CM07EM0FCK03I03K0C,,:::::::::Y07C,Y0FC,Y0CE,X01C7,X03838,X07018,^FS          ^CF0,60          ^FO620,50^FD1 of 1^FS          ^CF0,40          ^FO50,125^FDRoute ID: B312C18 | #XDPTG5RP^FS          ^CF0,40          ^FO50,180^FDFriday 16th February |  3:00 -  4:00pm^FS          ^CF0,30          ^FO50,250^GB700,3,3^FS          ^FO50,300^FDPauline Mckeon^FS          ^FO50,350^FD100 47B Maury Road^FS          ^FO50,400^FDLondon N16 7BP^FS          ^FO50,450^FDUnited Kingdom (UK)^FS          ^FO50,520^GB700,3,3^FS          ^FO50,570^FDType: TOSHI PLUS, Drop-Off^FS          ^FO50,620^FD^FS          ^FO50,670^FDQuantity: 1 (one) parcel^FS          ^FO50,740^GB700,3,3^FS          ^FX Third section with bar code.          ^FO50,780^BQN,2,10^FDMM:ATOSHI-W7RF2PRZ^FS          ^CF0,50          ^FO300,875^FDTOSHI-W7RF2PRZ^FS          ^XZ'
    end
    it 'works for toshi' do
      puts Vizualizpl::Convert::ToPdf.new(zpl: zpl).perform
    end
  end
end
# rubocop:enable Metrics/BlockLength
