def print_stack_trace(stack)
  stack.each do |entry|
    extra_label =
      if (entry.label != entry.base_label)
        " (#{entry.label})"
      else
        ""
      end
    puts "\u001b[31m#{entry.defined_class || entry.instance_class}\u001b[0m.\u001b[32m#{entry.base_label}\u001b[0m(#{entry.path}:#{entry.lineno})#{extra_label}"
  end
  puts "---"
end

def blocks_example
  print_stack_trace(caller_locations(0))

  1.times do
      print_stack_trace(caller_locations(0))

    1.times do
      print_stack_trace(caller_locations(0))
    end
  end
end

puts "Stacks for blocks_example:"
blocks_example


module Static
  def self.static_example
    print_stack_trace(caller_locations(0))
  end
end

puts "Stack for static_example:"
Static.static_example

module A
  class Super1
    def classes_example
      print_stack_trace(Thread.current.backtrace_locations)
    end
  end
end

module B
  class Super2 < A::Super1
    def classes_example
      super
    end
  end
end

module C
  class Super3 < B::Super2
    def classes_example
      super
    end
  end
end

module D
  class Super4 < C::Super3
    def classes_example
      super
    end
  end
end


puts "Stack for classes_example:"
D::Super4.new.classes_example
