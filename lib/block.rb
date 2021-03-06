module HotelSystem
  class Block
    MAX_ROOMS = 5
    attr_reader :rooms, :arrive_day, :depart_day, :discount, :reservations

    def initialize(rooms:, arrive_day:, depart_day:, discount: 0)
      raise ArgumentError, "Blocks can have a max of #{MAX_ROOMS} rooms." if rooms.length > MAX_ROOMS
      @rooms = rooms

      raise ArgumentError, "discount must be between 0 and 1" if discount < 0 || discount > 1

      @arrive_day = arrive_day
      @depart_day = depart_day
      @discount = discount
      @reservations = []
      raise ArgumentError, "Not all rooms are available in this Block" unless all_rooms_available?
      create_block_reservations
    end

    def all_rooms_available?
      rooms.each do |room|
        (arrive_day...depart_day).each do |day|
          return false unless room.available?(day)
        end
      end
      return true
    end

    def create_block_reservations
      all_reservations = []
      rooms.each do |room|
        reservation = HotelSystem::BlockReservation.new(room: room, arrive_day: arrive_day, depart_day: depart_day, block: self)
        all_reservations << reservation
        room.reservations << reservation
        @reservations << reservation
      end
      return all_reservations
    end

    def find_available_reservations
      availabe_reservations = reservations.select { |res| res.status == :AVAILABLE }
      return availabe_reservations
    end

    def book_block_reservation(reservation)
      raise ArgumentError, "Cannot be used on regular reservations" if reservation.class == HotelSystem::Reservation
      raise ArgumentError, "Reservation is Unavailable" if reservation.status == :UNAVAILABLE
      reservation.book_reservation
    end
  end
end
