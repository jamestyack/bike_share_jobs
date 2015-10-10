
class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end

# supports get from hash using dot notation e.g. "geometry.lat.1" (1 is array index)
# see http://stackoverflow.com/questions/6672007/how-do-you-access-nested-elements-of-a-hash-with-a-single-string-key
def get_from_hash(key, hash)
    key.to_s.split('.').inject(hash) { |h, k|
      h[k.is_i? ? k.to_i : k]
    }
end
