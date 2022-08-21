# frozen_string_literal: true

require_relative "spec_helper"

require "database_cleaner"
DatabaseCleaner.strategy = :deletion

RSpec.describe "ActiveRecord::SlottedCounterCache" do
  before(:each) do
    DatabaseCleaner.clean
  end

  include_examples "test ActiveRecord::CounterCache interface", WithSlottedCounter::Article, WithSlottedCounter::Comment

  context "counter requests more than max slot number" do
    let(:more_than_max_slotted_count) { 101 }

    it "increments counter" do
      article = WithSlottedCounter::Article.create!
      more_than_max_slotted_count.times do
        article_class.increment_counter(:comments_count, article.id)
      end
      expect(article.comments_count).to eq(more_than_max_slotted_count)
    end

    it "decrements counter" do
      article = WithSlottedCounter::Article.create!
      more_than_max_slotted_count.times do
        article_class.decrement_counter(:comments_count, article.id)
      end
      expect(article.comments_count).to eq(-more_than_max_slotted_count)
    end
  end
end
