class ResolveOrphanSponsorshipStatus
  def initialize(orphan)
    @orphan = orphan
  end

  def resolve
    if unsponsored?
      @orphan.orphan_sponsorship_status =
        OrphanSponsorshipStatus.find_by_name('Unsponsored')
    elsif previously_sponsored?
      @orphan.orphan_sponsorship_status =
        OrphanSponsorshipStatus.find_by_name('Previously Sponsored')
    elsif currently_sponsored?
      @orphan.orphan_sponsorship_status =
        OrphanSponsorshipStatus.find_by_name('Sponsored')
    end
  end

  private

  def unsponsored?
    @orphan.sponsorships.empty?
  end

  def previously_sponsored?
    @orphan.sponsorships.all_active.empty?
  end

  def currently_sponsored?
    @orphan.sponsorships.all_active.present?
  end
end
