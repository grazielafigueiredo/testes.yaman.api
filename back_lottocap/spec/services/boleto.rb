# frozen_string_literal: true

require "time"
require "utils/constant"
require "services/user"

class ApiBoleto
    include HTTParty
    base_uri "https://hmlapi.lottocap.com.br/api/Pagamento"
    headers "Content-Type" => "application/json", "Authorization" => Constant::Authorization


    @time = Time.now.strftime('%F')

    def self.post_AdicionarItemCarrinho(qtdItens)

        @AdicionarItemCarrinho = {
            "obj": {
                "idCarrinho": Constant::IdCarrinho,
                "idProduto": Constant::IdProduto,
                "idSerie": Constant::IdSerie,
                "qtdItens": qtdItens,
                "flPromoAtiva": false
            },
            "atualPagina": 1,
            "tamanhoPagina": 999
        }
        post("/AdicionarItemCarrinho", body: @AdicionarItemCarrinho.to_json)
    end

    def self.post_SucessoBoleto
        @SucessoBoleto = {
          "obj": {
            "idFormaPagamento": Constant::IdFormaPagamentoBoleto,
            "idCarrinho": Constant::IdCarrinho,
            "boletoSenderHash": "667a4c201f9cdaaa382f6c89180770243d6ca8f01ca6cdcf7a7aed56b684cadc"
   
          }
        }
        post('/PagarCarrinho', body: @SucessoBoleto.to_json)
      end
end


		
