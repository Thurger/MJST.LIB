function Card:is_value(values)
    if self.ability and self.ability.all_ranks then
        return true
    end

    for _, v in ipairs(values) do
        if v == self.get_id(self) then
            return true
        end
    end
end

function Card:get_ranks(values)
    local ret = values or {}

    if self.ability and self.ability.all_ranks then
        if SMODS and SMODS.Card and SMODS.Card.MAX_ID then
            for i = SMODS.Card.MAX_ID, 1, -1 do
                table.insert(ret, i)
            end
        else
            for i = 14, 1, -1 do
                table.insert(ret, i)
            end
        end
    else
        table.insert(ret, self:get_id())
    end

    return ret
end

function Card:compare_ranks(other_ranks, other_ret)
    local ret = other_ret or {}
    local ranks = Card:get_ranks()

    if type(other_ranks) == "table" then
        for _, rank in ipairs(ranks) do
            for _, other_rank in ipairs(other_ranks) do
                if rank == other_rank then
                    table.insert(ret, other_rank)
                end
            end
        end
    elseif type(other_ranks) == "number" then
        for _, rank in ipairs(ranks) do
            if rank == other_ranks then
                table.insert(ret, other_ranks)
            end
        end
    end

    return ret
end

local card_set_debuff_ref = Card.set_debuff
function  Card:set_debuff(should_debuff)
    if self.ability and self.ability.no_debuff then return end
    return card_set_debuff_ref(self, should_debuff)
end

local card_is_face_ref = Card.is_face
function Card:is_face(from_boss)
    return card_is_face_ref(self, from_boss) or (self.ability and self.ability.all_ranks) or false
end

local card_is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    return card_is_suit_ref(self, suit, bypass_debuff, flush_calc) or (self.ability and self.ability.all_suits) or false
end

local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    local ret = calculate_joker_ref(self, context) or {}

    if self.ability.set == "Joker" and not self.debuff then
        if context.individual then
            if context.cardarea == G.play then
                if self.ability.name == "Fibonacci" then
                    if context.other_card:get_id() ~= 2 and context.other_card:get_id() ~= 3 and context.other_card:get_id() ~= 5 and context.other_card:get_id() ~= 8 and context.other_card:get_id() ~= 14 then
                        if #context.other_card:compare_ranks({2, 3, 5, 8, 14}) > 0 then
                            ret.mult = ret.mult or 0
                            ret.card = ret.card or self
                            ret.mult = ret.mult + self.ability.extra
                        end
                    end
                end
            end
        end
    end

    return ret
end