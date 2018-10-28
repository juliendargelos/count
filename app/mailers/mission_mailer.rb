class MissionMailer < ApplicationMailer
  def to_referent(mission)
    @mission = mission

    mail(
      from: "#{@mission.user.full_name} <#{@mission.user.email}>",
      to: "#{@mission.referent.full_name} <#{@mission.referent.email}>",
      subject: "Devis #{@mission.name}"
    )
  end
end
