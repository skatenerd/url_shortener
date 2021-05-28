require 'securerandom'
class GenerateSlug
  def for_record_count(record_count)
   gen_random_string_with_length(length_for_record_count(record_count))

  end

  private

  def gen_random_string_with_length(length)
    SecureRandom.urlsafe_base64(length)[...length]
  end

  def length_for_record_count(record_count)
    [4, Math.log([record_count, 1].max, 64).to_i + 3].max
  end
end
