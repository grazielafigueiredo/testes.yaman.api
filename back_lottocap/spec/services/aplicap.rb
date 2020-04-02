# frozen_string_literal: true

class Aplicap
  def self.gerar_matriz_signo
    %(#{gerar_header}
#{gerar_body}
#{gerar_footer})
  end

  def self.gerar_header
    'HPARATY TECNOLOG3000112300010800001320SIGNO00014032020'
  end

  def self.gerar_body
    %(D000000001010203
D000000002010204
D000000003010204)
  end

  def self.gerar_footer
    'T000000003'
  end

  def self.signo
    signos = %w[01 02 03 04 05 06 07 08 09 10 11 12]

    signos.permutation(3).to_a
  end

  def processa_item(item)
    item.join.to_i
  end
end
