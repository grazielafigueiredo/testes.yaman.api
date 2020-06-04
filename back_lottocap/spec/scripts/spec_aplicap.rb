# frozen_string_literal: true

describe 'Aplicap' do
    context 'MAtriz aplicap' do
      before do
      @resultado = Aplicap.gerar_matriz_signo
      end
      it { 
          @esperado = %{HPARATY TECNOLOG3000112300010800001320SIGNO00014032020
D000000001010203
D000000002010204
D000000003010204
T000000003}
          expect(@resultado).to be_a String
          expect(@resultado).to eql @esperado
        }
    end

    context 'MAtriz Header' do
        before do
        @resultado = Aplicap.gerar_header
        end
        it { 
            @esperado = "HPARATY TECNOLOG3000112300010800001320SIGNO00014032020"
            expect(@resultado).to be_a String 
            expect(@resultado).to eql @esperado
          }
      end

      context 'count 1320' do 
        it {expect(Aplicap.signo.count).to eql 1320}
        it {expect(Aplicap.signo[0]).to eql ["01", "02", "03"]}
        it {expect(Aplicap.signo[-1]).to eql ["12", "11", "10"]}
      end
end