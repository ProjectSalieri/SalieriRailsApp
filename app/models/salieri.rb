class Salieri < ActiveRecord::Base

  # ジャンルカテゴライズのために形態素解析
  def parse_for_genre_categorize(document)
=begin
    t.each { |m|
      output += "#{m.surface} #{m.feature} #{m.start}\n"
    }
=end
  end

  def parse(document)
    if @tagger == nil
      @tagger = init_tagger
    end

    return @tagger.parse(document)
  end

  private

  # taggerの初期化
  def init_tagger
    ipadic_path = File.join(get_lib_dir, "nlp", "ipadic")

    # 解凍済みファイルは重いので初回のみ解凍
    if File.exist?(ipadic_path) == false
      require "zip/zip"
      Zip::ZipFile.open("#{ipadic_path}.zip") do |zip|
        zip.each do |entry|
          # { true } は展開先に同名ファイルが存在する場合に上書きする指定
          zip.extract(entry, File.join(File.dirname(ipadic_path), entry.to_s)) { true }
          end
      end
    end

    return Igo::Tagger.new(ipadic_path)
  end
end
