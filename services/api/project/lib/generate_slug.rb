require 'securerandom'
class GenerateSlug
  def for_record_count(record_count)
   gen_random_string_with_bytes(bytes_for_record_count(record_count))

  end

  private

  def gen_random_string_with_bytes(bytes)
    SecureRandom.urlsafe_base64(bytes)
  end

  def bytes_for_record_count(record_count)
    [3, Math.log([record_count, 1].max, 256).to_i + 2].max
  end
end
