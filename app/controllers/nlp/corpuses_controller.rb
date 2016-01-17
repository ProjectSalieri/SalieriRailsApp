class Nlp::CorpusesController < ApplicationController

  def index
    @word_names = Word.all.pluck(:name).uniq()
    @doc_category_type = DocCategoryType.type_genre
    if params.key?(:doc_catetory_type)
      @doc_category_type = DocCategoryType.find_by({:name_en => params[:doc_catetory_type]})
    end
  end

end
