class QuestionController < ApplicationController
  skip_before_action :verify_authenticity_token
  
    def one
      return render :json => {message: "É Necessario enviar um corpo via JSON"}, status: 400 unless params.dig(:input).present?
      concat = ""
      params.dig(:input).each do |dados|
        concat += parse_string_one(dados.values)
        concat += "\n"
      end
      return render json: concat, status: 200
    end
  
    def parse_string_one(values)
      string_concat = ""
      parse = values.map { |value| value[0, 11] }
      parse.each do |value|
        string_concat += value
        string_concat += " " if value.length < 11
      end
      string_concat
    end


    #Questao numero 2

    def two
      return render :json => {message: "É Necessario enviar um corpo via JSON"}, status: 400 unless params.dig(:input).present?
      config = YAML.load(File.open('config/format_faster.yaml'))
      concat = ''
      params[:input].each do |input|
        result = configurationTwo(config, input)
        concat += parse_string_two(result)
        concat += "\n"
      end
      return render json: concat, status: 200
    end

    def configurationTwo(config, input)
      res_conf = []
      config['configuration_two'].each do |conf|
        res_conf << chave_valor_two(conf[0], conf[1], input)
      end
      res_conf
    end

    def chave_valor_two(key, values, input)
      obj = []
      obj << input[key][0, values['length']]
      tamanho_max = values['length']
      tamanho_real = obj[0].length
      str = obj[0]
      quantidade_que_falta = tamanho_max - tamanho_real
      if !quantidade_que_falta.zero?
        prencher = ''
        index = str.length
        while index < tamanho_max
          prencher += values['padding'] == "zeroes" ? "0" : " "
          index += 1
        end
        if values['align'] == 'left'
          resposta = obj[0] += prencher
        else
          resposta = prencher += obj[0]
        end
      else
        resposta = obj[0]
      end
      resposta
    end

    def parse_string_two(values)
      string_concat = ""
      values.each do |value|
        string_concat += value
      end
      string_concat
    end

    #Questao numero 3

    def three
      return render :json => {message: "É Necessario enviar um corpo via JSON"}, status: 400 unless params.dig(:input).present?
      config = YAML.load(File.open('config/format_faster.yaml'))
      concat = ''
      result = configurationThree(config, params[:input])
      #concat += parse_string_two(result)
      #concat += "\n"
      return render json: result, status: 200
    end

    def configurationThree(config, input)
      res_conf = {}
      times = config['configuration_two']
      config['configuration_two'].each do |conf|
        quantidade_caracte = 0
        res_conf[chave_valor_three(conf[0], conf[1], input)[0][0]] = chave_valor_three(conf[0], conf[1], input)[0][1]
        cont_caract = countInput(conf[1], input)
        input = input.last(input.length - cont_caract )
      end
      res_conf
    end

    def countInput(values, input)
      cont_caract = input.slice(0, values['length']).length
    end

    def chave_valor_three(key, values, input)
      obj = []
      obj << "#{key}:"
      obj << input.slice(0, values['length'])
      obj.length - values['length']

      if values['align'] == 'right'
        if values['padding'] == 'spaces' && obj[1].first == ' '
          obj[1].sub!(/^ +/,'')
        elsif values['padding'] == 'zeroes' && obj[1].first == '0'
          obj[1].sub!(/^[0]+/,'')
        end
      else
        if values['padding'] == 'spaces' && obj[1].last == ' '
          obj[1].sub!(/ +/,'')
        elsif values['padding'] == 'zeroes' && obj[1].last == '0'
          obj[1].sub!(/[0]+/,'')
        end
      end
      [obj]
    end
end
