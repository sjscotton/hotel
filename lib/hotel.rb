require "date"

require_relative "room"
require_relative "reservation"
require_relative "block"
require_relative "block_reservation"

module HotelSystem
  class Hotel
    attr_reader :reservations, :blocks, :id
    attr_accessor :rooms

    def initialize(id:, rooms: [], reservations: [], blocks: [])
      @id = id
      @rooms = HotelSystem::Room.create_rooms(rooms)
      @reservations = reservations
      @blocks = blocks
    end

    #### NOT SURE IF I NEED THIS
    def list_rooms
      room_list = @rooms.map { |room| room.id }
      return room_list
    end

    def add_reservation(reservation)
      @reservations << reservation
    end

    def create_date_object(date)
      date_object = Date.parse(date)
      return date_object
    end

    def create_reservation(room, arrive_day, depart_day)
      reservation = HotelSystem::Reservation.new(room: room, arrive_day: arrive_day, depart_day: depart_day)
      return reservation
    end

    def book_reservation(room, first_day, last_day)
      arrive_day = create_date_object(first_day)
      depart_day = create_date_object(last_day)
      (first_day...last_day).each do |day|
        raise ArgumentError, "Room not avaiable for that date" if !is_room_availabile?(room, day)
      end
      reservation = create_reservation(room, arrive_day, depart_day)
      add_reservation(reservation)
      room.add_reservation(reservation)
      return reservation
    end

    def is_room_availabile?(room, date)
      return room.available?(date)
    end

    def reservations_by_date(date)
      date_object = create_date_object(date)
      reservations = @reservations.select { |res| res.date_range.include?(date_object) }
      return reservations
    end

    def get_available_rooms(first_day, last_day)
      arrive_day = create_date_object(first_day)
      depart_day = create_date_object(last_day)
      available_rooms = @rooms.clone
      (first_day...last_day).each do |day|
        date = create_date_object(day)
        available_rooms = available_rooms.select { |room| is_room_availabile?(room, date) == true }
      end
      return available_rooms
    end

    def create_block(rooms, first_day, last_day, discount)
      new_block = HotelSystem::Block.new(rooms: rooms, first_day: first_day, last_day: last_day, discount: discount)
      new_block.create_block_reservations
      @blocks << new_block
      return new_block
    end

    def available_block_rooms(block)
    end

    def reserve_block_room(block, room)
    end
  end
end
