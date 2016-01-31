class Nlp::CorpusesController < ApplicationController

  def index
    @doc_category_type = DocCategoryType.type_genre
    if params.key?(:doc_category_type)
      @doc_category_type = DocCategoryType.find_by({:name_en => params[:doc_category_type]})
    end
    @words = Word.where(:doc_category_type_id => @doc_category_type.id).includes(:doc_category_infos)
  end

end
