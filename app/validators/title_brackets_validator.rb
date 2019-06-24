class TitleBracketsValidator < ActiveModel::Validator
  BRACKETS = { "{" => "}", "[" => "]", "(" => ")" }

  def validate(record)
    stack = []
    last_char = nil

    record.title.each_char do |char|
      return empty_brackets(record) if BRACKETS[last_char] == char

      stack << char if opening_bracket?(char)
      return unmatching_brackets(record) if closing_bracket?(char) && BRACKETS[stack.pop] != char

      last_char = char
    end

    unmatching_brackets(record) if stack.present?
  end

  private

  def opening_bracket?(char)
    BRACKETS.keys.include?(char)
  end

  def closing_bracket?(char)
    BRACKETS.values.include?(char)
  end

  def unmatching_brackets(record)
    record.errors[:title] << "must contain only matching brackets."
  end

  def empty_brackets(record)
    record.errors[:title] << "mustn't contain empty brackets."
  end
end
